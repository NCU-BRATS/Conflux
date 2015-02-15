module TimeHelper

  def time_format_absolute_tag( time, options={} )
    if time.present?
      options = options.symbolize_keys

      options[:class] = 'time'
      options[:data] ||= {}
      options[:data][:moment] = time.to_formatted_s(:iso8601)
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

      options[:class] = 'time'
      options[:data] ||= {}
      options[:data][:moment] = time.to_formatted_s(:iso8601)
      options[:data][:type] = 'relative'

      content_tag( 'span', '', options )
    end
  end

end
