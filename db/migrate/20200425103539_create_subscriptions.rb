class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :account
      t.string :plan
      t.datetime :active_until

      t.timestamps
    end
  end
end
