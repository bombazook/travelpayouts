class SubscriptionsController < ApplicationController
  include Subscriptions

  def create
    CreateService.call(params: params, content_type: request.content_type) do |s|
      respond_with(*s.responders_params)
    end
  end

  def update
    UpdateService.call(params: params, content_type: request.content_type) do |s|
      respond_with(*s.responders_params)
    end
  end
end
