class SubscriptionsService < ApplicationService
  include ParamsService

  protected

  def user
    @user ||= User.find(parents_params[:user_id]) if parents_params[:user_id]
  end

  def program
    @program ||= Program.find(parents_params[:program_id]) if parents_params[:program_id]
  end

  def parent
    @parent ||= (params[:user_id] ? user : program) || user || program
  end

  def path_parents_params
    params.slice(:user_id, :program_id).permit(:user_id, :program_id)
  end

  alias_method :parents_params, :path_parents_params
end
