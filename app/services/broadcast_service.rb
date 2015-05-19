class BroadcastService
  include Wisper::Publisher

  subscribe(EventCreateListener, async: true)

  class << self
    def fire(event, *args)
      instance.send(:broadcast, event, *args)
    end

    def instance
      @instance ||= new
    end
  end
end
