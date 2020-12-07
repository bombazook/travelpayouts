class AddSubscriptionsBanned < ActiveRecord::Migration[6.0]
  def change
    add_column(:subscriptions, :banned, :boolean, default: false, null: false)
    add_index(:subscriptions, [:user_id, :program_id, :banned])
  end
end
