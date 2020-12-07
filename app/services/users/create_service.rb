module Users
  class CreateService < UsersService
    include JsonapiService

    def call
      @user = User.create extract_resource_params(:user, only: %i[email name])
    end

    def responders_params
      [@user]
    end
  end
end
