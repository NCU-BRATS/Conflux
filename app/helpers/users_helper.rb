module UsersHelper

  def avatar_tag( user, options={} )
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

  def user_tag( user, options={} )
    options = options.symbolize_keys
    options[:href] = user_link( user )
    content_tag( 'a', user.name, options )
  end

  def user_luxury_tag( user, options={} )
    options.merge!( { :class => 'ui image label', :href => user_link( user ) } )
    content_tag( 'a', options ) do
      avatar_tag( user, :size => 25 ) + user.name
    end
  end

  def user_img_tag( user, options={} )
    options.merge!( { :class => 'ui image label', :href => user_link( user ) } )
    content_tag( 'a', options ) do
      avatar_tag( user, :size => 25 )
    end
  end

  def user_link( user )
    user_path( user.slug )
  end

end
