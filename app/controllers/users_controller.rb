class UsersController < ApplicationController
  include Users

  def show
    ShowService.call(params: params) do |s|
      respond_with(*s.responders_params)
    end
  end

  def create
    CreateService.call(params: params, content_type: request.content_type) do |s|
      respond_with(*s.responders_params)
    end
  end
end
