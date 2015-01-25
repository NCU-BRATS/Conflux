# http://blog.55minutes.com/2014/02/easier-nested-layouts-in-rails-34/
module LayoutsHelper

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(:file => "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

end
