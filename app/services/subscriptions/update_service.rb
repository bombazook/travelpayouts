module Subscriptions
  class UpdateService < SubscriptionsService
    include JsonapiService

    def call
      @subscription = Subscription.find(params[:id])
      @subscription.update(banned)
    end

    def responders_params
      [@subscription]
    end

    private

    def banned
      extract_resource_params :subscription, only: [:banned]
    end
  end
end
