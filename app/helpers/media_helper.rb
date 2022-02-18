module MediaHelper
  def variant_image_tag(attachment, variant_name, options = {})
    variant = attachment.variant(variant_name)

    if attachment.service.exist?(variant.key)
      image_tag variant, options
    else
      image_tag picture, options
    end
  end
end
