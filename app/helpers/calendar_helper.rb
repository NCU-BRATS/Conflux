module CalendarHelper

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