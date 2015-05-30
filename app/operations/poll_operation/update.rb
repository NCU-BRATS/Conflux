module PollOperation
  class Update < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      super(poll)
    end

    def process(params)
      save do |hash|
        hash[:options_attributes] = hash.delete(:options)
        @model.update(hash)
      end if validate(params[:poll])
    end
  end
end
