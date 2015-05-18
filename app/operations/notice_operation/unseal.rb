module NoticeOperation
  class Unseal
    def initialize(current_user, notice)
      @current_user = current_user
      @notice       = notice
    end

    def process
      @notice.unseal!
      @notice.save
    end
  end
end
