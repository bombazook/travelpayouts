module JsonapiService
  include JSONAPI::Deserialization
  include ContentTypeService

  def extract_resource_params(resource_name, relations: [], only: [])
    if content_type == 'application/vnd.api+json'
      jsonapi_deserialize(params, only: (relations + only))
    else
      relationship_ids = relations.map { |n| "#{n}_id" }
      allowed_params = relationship_ids + only
      params.require(resource_name).permit(*allowed_params).as_json
    end
  end
end
