module SprintsHelper

  def sprint_tag( sprint, options={} )
    options = options.symbolize_keys
    options[:href] = project_sprint_path( sprint.project, sprint )
    content_tag( 'a', sprint.title, options )
  end

  def sprint_luxury_tag( sprint, options={} )
    options.merge!( { :class => 'ui image label', :href => project_sprint_path( sprint.project, sprint ) } )
    content_tag( 'a', options ) do
      model_icon_tag( Sprint ) + sprint.title
    end
  end

end