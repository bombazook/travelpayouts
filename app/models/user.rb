class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :programs, through: :subscriptions
end
