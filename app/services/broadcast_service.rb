class BroadcastService
  include Wisper::Publisher

  def initialize
    if BroadcastService.listener_toggle
      subscribe(EventCreateListener, async: true)
      subscribe(NoticeCreateListener, async: true)
    end
  end

  class << self
    attr_writer :listener_toggle

    def listener_toggle
      @listener_toggle ||= !(Rails.env.test?)
    end

    def fire(event, *args)
      new.send(:broadcast, event, *args)
    end
  end
end
