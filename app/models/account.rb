class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_one :subscription

  after_create :setup_subscription

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def setup_stripe_subscription source
    # find subscription in database
    plan = subscription

    qty = case plan
    when "small"
      3
    when "medium"
      9
    when "large"
      100
    end

    stripe_params = {
      :name => self.full_name,
      :description => "Customer id: #{self.id}",
      :email => self.email,
      :source => source
    }

    if plan.stripe_customer_id.present?
      # load stripe subscription and update customer plan
      account = Stripe::Customer.retrieve(plan.stripe_customer_id)
    else
      # if no stripe customer id is found on subscription, then create new stripe subscription
      account = Stripe::Customer.create(stripe_params)
    end

    # create / update subscription
    if plan.stripe_subscription_id.present?
      subscription = Stripe::Subscription.update(plan.stripe_subscription_id, items: [
        ['plan' => "Premium", "quantity" => qty]      
      ])
    else
      subscription = Stripe::Subscription.create(customer: plan.stripe_customer_id, items: [
        ['plan' => "Premium", "quantity" => qty]
      ])
    end

    # update subscription in database to store stripe sub id
    plan.update(stripe_subscription_id: subscription.id)
  end

  private

  def setup_subscription
    Subscription.create(account_id: self.id, plan: "free", active_until: 1.month.from_now)
  end
end
