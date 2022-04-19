module AvatarHelper
  def avatar_list(users, **params)
    return if users.empty?

    content_tag(:div, class: 'avatar-list') do
      users.map do |user|
        avatar_tag(user, **params)
      end.join(' ').html_safe
    end
  end

  def avatar_tag(user, size: :small, title_prefix: nil)
    path = user.has_avatar? ? user.avatar_url(size) : asset_path('blank-avatar.png')
    image_tag path, class: "avatar avatar-#{size}", alt: user.display_name, title: "#{title_prefix}#{user.display_name}"
  end

  def avatar_link(user, size: :small, title_prefix: nil)
    content_tag :a, href: '#', class: 'avatar-link' do
      avatar_tag(user, size:, title_prefix:)
    end
  end
end
