class AddStripeCustomerIdToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :stripe_customer_id, :string
  end
end
