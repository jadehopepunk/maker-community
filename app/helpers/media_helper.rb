module MediaHelper
  def image_model_tag(image, options = {})
    return nil unless image

    default_options = {
      alt: image.alt_text,
      class: 'image-model'
    }
    image_tag image.file, default_options.merge(options)
  end

  def variant_image_tag(attachment, variant_name, options = {})
    variant = attachment.variant(variant_name)

    if variant.key
      image_tag variant, options
    else
      image_tag attachment, options
    end
  end
end
