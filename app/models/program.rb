class Program < ApplicationRecord
  attr_readonly :subscriptions_count
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  scope :popular, -> { order('subscriptions_count DESC') }
end
