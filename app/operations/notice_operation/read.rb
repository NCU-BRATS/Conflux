module NoticeOperation
  class Read
    def initialize(current_user, notice)
      @current_user = current_user
      @notice       = notice
    end

    def process
      @notice.read!
      @notice.save
    end
  end
end
