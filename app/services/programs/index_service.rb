module Programs
  class IndexService < ApplicationService
    include ParamsService

    def responders_params *args
      if user
        [user, presenter(not_banned, *args)]
      else
        [presenter(programs, *args)]
      end
    end

    private

    def presenter scoped, *args
      CollectionPresenter.new(scoped, *args).filtered.popular
    end

    def programs
      @programs ||= user ? user.programs : Program.all
    end

    def not_banned
      programs.where('subscriptions.banned = ?', false)
    end

    def user
      @user ||= User.find(params[:user_id]) if params[:user_id]
    end
  end
end
