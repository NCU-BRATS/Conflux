module ApplicationHelper
  def avatar_tag(user, options={})
    if user.try(:avatar_url).present?
      image_tag(user.avatar_url, options)
    else
      options = options.symbolize_keys
      options[:alt] = options[:alt] || user.name

      if size = options.delete(:size)
        options[:width] = options[:height] = size
      end

      options[:data] ||= {}
      options[:data][:gravatar] = user.email
      options[:data][:size] = size

      tag('img', options)
    end
  end
end
