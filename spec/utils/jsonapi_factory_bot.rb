class JsonApiAttributes < FactoryBot::Strategy::Build
  def result(evaluation)
    item = super(evaluation)
    JSONAPI::Rails.serializer_class(item, false).new(item).serializable_hash
  end
end

FactoryBot.register_strategy(:json_api_attributes_for, JsonApiAttributes)
