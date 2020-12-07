class ApplicationController < ActionController::API
  self.responder = ApplicationResponder
  respond_to :json, :jsonapi

  include JSONAPI::Deserialization
  include JSONAPI::Errors
end
