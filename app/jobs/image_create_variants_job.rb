class ImageCreateVariantsJob < ApplicationJob
  queue_as :default

  VARIANT_NAMES = [:thumb].freeze

  def perform(image_id)
    image = Image.find image_id
    file = image.file

    VARIANT_NAMES.each do |variant_name|
      file.variant(variant_name).processed
    end
  end
end
