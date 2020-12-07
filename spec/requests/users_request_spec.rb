require 'rails_helper'

RSpec.describe 'Users requests', type: :request do
  include_context 'headers'

  describe 'GET /users/:id' do
    let(:users) { create_list(:user, 10) }

    ['application/json', 'application/vnd.api+json'].each do |a|
      context "with ACCEPT:#{a}" do
        let(:accept) { a }

        it 'returns json api encoded data' do
          get user_path(users[0]), headers: headers
          serialized_object = UserSerializer.new(users[0]).serializable_hash.as_json
          expect(JSON.parse(response.body)).to be_eql(serialized_object)
        end
      end
    end
  end

  shared_examples 'post request' do
    it 'returns http created' do
      post users_path, params: params, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'serializes user to jsonapi' do
      pars = params
      expect(UserSerializer).to receive(:new).and_wrap_original do |m, *args|
        expect(args.first).to be_a(User)
        m.call(*args)
      end
      post users_path, params: pars, headers: headers
    end
  end

  describe 'POST /users' do
    ['application/json', 'application/vnd.api+json'].each do |a|
      context "with ACCEPT:#{a}" do
        let(:accept) { a }

        context 'with CONTENT-TYPE:application/json' do
          include_examples 'post request' do
            let(:content_type) { 'application/json' }
            let(:params) { { user: attributes_for(:user) }.to_json }
          end
        end

        context 'with CONTENT-TYPE:application/vnd.api+json' do
          include_examples 'post request' do
            let(:content_type) { 'application/vnd.api+json' }
            let(:params) { json_api_attributes_for(:user).to_json }
          end
        end
      end
    end
  end
end
