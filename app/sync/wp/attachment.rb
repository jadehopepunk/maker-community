require 'image_processing/mini_magick'

module Wp
  class Attachment < Wp::Base
    self.table_name = 'wp_posts'
    include Concerns::IsPostType

    default_scope { where(post_type: 'attachment') }
    scope :images, -> { where(post_mime_type: 'image/jpeg') }

    class << self
      def dest_class
        ::Image
      end

      def sync
        images.find_each(&:import_if_new)
      end

      def import_async
        images.find_each do |attatchment|
          WpAttachmentImportJob.perform_later(attatchment.ID)
        end
      end
    end

    def import_new
      dest = dest_class.create!(
        wordpress_post_id: self.ID,
        alt_text: meta['_wp_attachment_image_alt'],
        caption: post_excerpt,
        created_at: post_date
      )

      tempfile = Down.download(guid)

      processed = ImageProcessing::MiniMagick
                  .source(tempfile)
                  .resize_to_limit(1080, 810)
                  .call

      dest.file.attach(io: processed, filename: post_name)

      puts "imported image #{self.ID}: #{dest.caption || dest.alt_text}"
      dest
    end
  end
end
