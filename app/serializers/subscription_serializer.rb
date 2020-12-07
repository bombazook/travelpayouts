class SubscriptionSerializer
  include JSONAPI::Serializer
  belongs_to :program
  belongs_to :user
  attribute :banned
end
