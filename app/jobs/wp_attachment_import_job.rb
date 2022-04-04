class WpAttachmentImportJob < ApplicationJob
  queue_as :default

  def perform(wordpress_post_id)
    attachment = Wp::Attachment.find(wordpress_post_id)
    attachment.import_if_new
  end
end
