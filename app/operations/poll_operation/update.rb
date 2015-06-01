module PollOperation
  class Update < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      super(poll)
    end

    def process(params)
      params[:poll][:options_attributes].each do |k, v|
        v['title'] = 1 if v['_destroy'] == '1' # hack to pass validation for options will be deleted.
      end

      save do |hash|
        hash[:options_attributes] = hash.delete(:options)
        @model.update(hash)
      end if validate(params[:poll])
    end
  end
end
