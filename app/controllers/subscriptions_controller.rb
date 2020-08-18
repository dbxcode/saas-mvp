class SubscriptionsController

  def choose_plan
    plan = params[:plan]
    qty = case plan
    when 'small'
      3
    when 'medium'
      9
    when 'large'
      100
    end

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: 'plan_HA5Ijv30550jbw',
        quantity: qty,
      }],
      mode: 'subscription',
      success_url: stripe_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: stripe_cancel_url
    )

    render "accounts/confirm_subscription"
  end

  def subscribe_to_plan
    plan = params[:plan]

    @subscription = current_account.subscription
    if @subscription.present? && @subscription.update(plan: plan)
      # plan updated successfully
      current_account.setup_stripe_subscription
    else
      # plan was not updated
    end
  end

end
