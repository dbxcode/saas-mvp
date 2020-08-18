# stripe configuration

Stripe.api_key             = ENV['STRIPE_SECRET_KEY']     # e.g. sk_live_...
StripeEvent.signing_secret = ENV['STRIPE_SIGNING_SECRET'] # e.g. whsec_...

StripeEvent.configure do |events|
  events.subscribe 'charge.failed' do |event|
    event.class       #=> Stripe::Event
    event.type        #=> "charge.failed"
    event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
  end

  events.subscribe 'charge.succeeded' do |event|
    event.class       #=> Stripe::Event
    event.type        #=> "charge.succeeded"
    data = event.data.object

    puts "Amount: #{data.amount}"
    puts "Description: #{data.description}"

    if data.paid
      # extend account access
      
    end
  end

  events.all do |event|
    # Handle all event types - logging, etc.
  end
end
