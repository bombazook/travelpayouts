class ProgramsController < ApplicationController
  include Programs

  def index
    IndexService.call(params: params) do |s|
      respond_with(*s.responders_params(term: params[:term]))
    end
  end
end
