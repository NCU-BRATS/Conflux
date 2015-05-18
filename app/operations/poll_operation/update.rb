module PollOperation
  class Update < BaseForm

    def initialize(current_user, poll)
      @current_user = current_user
      super({poll: poll})
    end

    def process(params)
      save do |hash|
        hash[:poll][:options_attributes] = hash[:poll].delete(:options)
        @model[:poll].update(hash[:poll])
      end if validate(params[:poll])
    end
  end
end
