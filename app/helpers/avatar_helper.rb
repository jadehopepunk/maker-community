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
    if user.has_avatar?
      image_tag user.avatar_url(size), class: "avatar avatar-#{size}", alt: user.display_name,
                                       title: "#{title_prefix}#{user.display_name}"
    end
  end
end
