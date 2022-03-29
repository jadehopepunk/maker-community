class SlackUser < ApplicationRecord
  AVATAR_SIZES = {
    xsmall: 48,
    small: 48,
    large: 512
  }.freeze

  belongs_to :user

  def has_avatar?
    image_48.present?
  end

  def avatar_url(size)
    raise ArgumentError unless AVATAR_SIZES.key?(size)

    send("image_#{AVATAR_SIZES[size]}")
  end
end
