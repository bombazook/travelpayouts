require 'rails_helper'

RSpec.describe 'Subscriptions requests', type: :request do
  include_context 'headers'

  shared_examples 'successful create' do
    let(:path) { File.join(*[path_base, subscriptions_path].flatten.compact) }
    it 'returns http 201 status' do
      post path, params: body, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'serializes subscription to jsonapi' do
      b = body
      expect(SubscriptionSerializer).to receive(:new).and_wrap_original do |m, *args|
        expect(args.first).to be_a(Subscription)
        m.call(*args)
      end
      post path, params: b, headers: headers
    end
  end

  shared_examples 'requests' do |operation|
    context 'with :user_id in url params and :program_id in body' do
      include_examples "successful #{operation}" do
        let(:path_base) { user_path(user) }
        let(:body_attrs) { { program_id: program.id, user_id: nil } }
      end
    end

    context 'with :program_id in url params and :user_id in body' do
      include_examples "successful #{operation}" do
        let(:path_base) { [programs_path, program.id.to_s] }
        let(:body_attrs) { { user_id: user.id, program_id: nil } }
      end
    end
  end

  describe 'POST /subscriptions' do
    let!(:user) { create(:user) }
    let!(:program) { create(:program) }

    ['application/json', 'application/vnd.api+json'].each do |a|
      context "with ACCEPT:#{a}" do
        let(:accept) { a }

        context 'with CONTENT-TYPE:application/json' do
          include_examples 'requests', 'create' do
            let(:content_type) { 'application/json' }
            let(:body) { { subscription: attributes_for(:subscription, **body_attrs) }.to_json }
          end
        end

        context 'with CONTENT-TYPE:application/vnd.api+json' do
          include_examples 'requests', 'create' do
            let(:content_type) { 'application/vnd.api+json' }
            let(:body) { json_api_attributes_for(:subscription, **body_attrs).to_json }

            context 'with :user_id and :program_id in body' do
              include_examples 'successful create' do
                let(:body_attrs) { { user_id: user.id, program_id: program.id } }
                let(:path_base) { nil }
              end
            end
          end
        end
      end
    end

    describe 'errors rendering' do
      let(:accept) { 'application/vnd.api+json' }
      let(:content_type) { 'application/json' }
      let!(:existing_subscription) { Subscription.create(user: user, program: program) }
      let(:body) { { subscription: attributes_for(:subscription, program_id: program.id) }.to_json }

      it 'renders errors if duplicate subscription creates' do
        post user_subscriptions_path(user), params: body, headers: headers
        expect(JSON.parse(response.body)).to include 'errors'
      end
    end
  end

  shared_examples 'successful patch' do
    let(:path) { subscription_path(subscription) }

    it 'returns http 200 status' do
      patch path, params: body, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'serializes user to jsonapi' do
      b = body
      expect(SubscriptionSerializer).to receive(:new).and_wrap_original do |m, *args|
        expect(args.first).to be_a(Subscription)
        m.call(*args)
      end
      patch path, params: b, headers: headers
    end
  end

  describe 'PATCH /subscriptions' do
    let!(:user) { create(:user) }
    let!(:program) { create(:program) }
    let(:subscription) { create(:subscription, user: user, program: program) }

    ['application/json', 'application/vnd.api+json'].each do |a|
      context "with ACCEPT:#{a}" do
        let(:accept) { a }

        context 'with CONTENT-TYPE:application/json' do
          let(:content_type) { 'application/json' }
          let(:body) { { subscription: { banned: true } }.to_json }
          include_examples 'successful patch'
        end

        context 'with CONTENT-TYPE:application/vnd.api+json' do
          let(:content_type) { 'application/vnd.api+json' }
          let(:body) do
            subscription.banned = true
            SubscriptionSerializer.new(subscription, { fields: { subscription: [:banned] } }).to_json
          end
          include_examples 'successful patch'
        end
      end
    end
  end
end
