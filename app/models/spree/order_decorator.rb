Spree::Order.class_eval do
  def token
    guest_token
  end
end
