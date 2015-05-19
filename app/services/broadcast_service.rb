class BroadcastService
  include Wisper::Publisher

  def initialize
    subscribe(EventCreateListener, async: true)
    subscribe(NoticeCreateListener, async: true)
  end

  class << self
    def fire(event, *args)
      instance.send(:broadcast, event, *args)
    end

    def instance
      @instance ||= new
    end
  end
end
