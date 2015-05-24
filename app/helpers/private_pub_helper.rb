module PrivatePubHelper
  # PrivatePub view helper to generate ujs tag
  def subscribe_to_ujs(channel)
    subscription = PrivatePub.subscription(:channel => channel)
    content_tag('div', nil, {data: subscription.merge({'private-pub': true})})
  end
end
