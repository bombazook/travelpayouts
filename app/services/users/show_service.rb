module Users
  class ShowService < UsersService
    def call
      @user = User.find(params[:id])
    end

    def responders_params
      [@user]
    end
  end
end
