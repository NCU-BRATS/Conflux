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
    if time.present?
      options = options.symbolize_keys

      options[:data] ||= {}
      options[:data][:moment] = time.to_s
      options[:data][:type] = 'absolute'

      unless ( format = options.delete(:format) ).nil?
        options[:data][:format] = format
      end

      content_tag( 'span', '', options )
    end
  end

  def time_format_relative_tag( time, options={} )
    if time.present?
      options = options.symbolize_keys

      options[:data] ||= {}
      options[:data][:moment] = time.to_s
      options[:data][:type] = 'relative'

      content_tag( 'span', '', options )
    end
  end

  def clndr_tag( options={} )

    name = options[:name] ||= 'custom'

    calendar = Clndr.new( name )

    if options[:single_events].present?
      options[:single_events].each { |event| calendar.add_event( event[:date], event[:name] ||= '' ) }
    end

    if options[:multiple_events].present?
      options[:multiple_events].each { |event| calendar.add_multiday_event( event[:start_date], event[:end_date], event[:name] ||= '' ) }
    end

    if options[:template].present?
      calendar.template = options[:template]
    end

    show_calendar( name, options[:html] || {} )
  end

end
