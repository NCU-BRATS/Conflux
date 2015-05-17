class Notice < ActiveRecord::Base
  class Seal
    def initialize(current_user, notice)
      @current_user = current_user
      @notice       = notice
    end

    def process
      @notice.seal!
      @notice.save
    end
  end
end
