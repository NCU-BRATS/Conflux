module ApplicationHelper
  def avatar_tag(user, options={})
    options.merge!({:class => 'img-rounded'})
    if user.try(:avatar_url).present?
      image_tag(user.avatar_url, options)
    else
      options = options.symbolize_keys
      options[:alt] = options[:alt] || user.name

      if ( size = options.delete(:size) ).present?
        options[:width] = options[:height] = size
      end

      options[:data] ||= {}
      options[:data][:gravatar] = user.email
      options[:data][:size] = size

      tag('img', options)
    end
  end

  def time_format_absolute_tag( time, options={} )
    options = options.symbolize_keys

    options[:data] ||= {}
    options[:data][:moment] = time.to_s
    options[:data][:type] = 'absolute'

    unless ( format = options.delete(:format) ).nil?
      options[:data][:format] = format
    end

    tag( 'span', options )
  end

  def time_format_relative_tag( time, options={} )
    options = options.symbolize_keys

    options[:data] ||= {}
    options[:data][:moment] = time.to_s
    options[:data][:type] = 'relative'

    tag( 'span', options )
  end

end
