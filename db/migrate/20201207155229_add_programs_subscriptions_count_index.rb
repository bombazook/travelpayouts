class AddProgramsSubscriptionsCountIndex < ActiveRecord::Migration[6.0]
  def change
    add_index(:programs, 'subscriptions_count DESC')
  end
end
