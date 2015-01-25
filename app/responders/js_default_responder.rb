module Responders

  module JsDefaultResponder
    def to_js
      super
    rescue ActionView::MissingTemplate
      render 'layouts/application'
    end
  end

end
