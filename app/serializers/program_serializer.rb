class ProgramSerializer
  include JSONAPI::Serializer
  attributes :title, :description
end
