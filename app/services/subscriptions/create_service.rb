module Subscriptions
  class CreateService < SubscriptionsService
    include JsonapiService

    def call
      @subscription = Subscription.create(parents_params)
    end

    def responders_params
      [parent, @subscription]
    end

    private

    def resource_params
      if params[:user_id]
        extract_resource_params :subscription, relations: [:program]
      elsif params[:program_id]
        extract_resource_params :subscription, relations: [:user]
      else
        extract_resource_params :subscription, relations: %i[user program]
      end
    end

    def parents_params
      path_parents_params.reverse_merge resource_params
    end
  end
end
