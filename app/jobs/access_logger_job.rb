class AccessLoggerJob < ActiveJob::Base
  queue_as :low

  def perform(param)
    AccessLog.create(param)
  end
end
