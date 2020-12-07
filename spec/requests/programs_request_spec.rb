require 'rails_helper'

RSpec.describe 'Programs requests', type: :request do
  include Rails.application.routes.url_helpers

  include_context 'headers'

  let!(:programs) { create_list(:program, 10) }

  shared_examples 'programs index' do
    ['application/json', 'application/vnd.api+json'].each do |a|
      context "with ACCEPT:#{a}" do
        let(:accept) { a }

        it 'returns http success' do
          get path, headers: headers
          expect(response).to have_http_status(:success)
        end

        it 'serializes programs collection' do
          expect(ProgramSerializer).to receive(:new).and_wrap_original do |m, *args|
            expect([args.first].flatten).to all(be_a(Program))
            m.call(*args)
          end
          get path, headers: headers
        end
      end
    end
  end

  describe 'programs#index' do
    let(:user) do
      create(:user) do |u|
        create(:program, users: [u])
      end
    end

    include_examples 'programs index' do
      let(:path) { programs_path }
    end

    context 'with parent user' do
      include_examples 'programs index' do
        let(:path) { user_programs_path(user) }
      end
    end

    context 'with ?term=<term>' do
      let(:accept) { 'application/json' }
      context 'term=<one letter>' do
        let!(:additional_programs) do
          5.times.map { |i| create(:program, title: "z #{i}") }
        end

        include_examples 'programs index' do
          let(:term) { 'z' }
          let(:path) { programs_path(term: term) }

          it 'returns only programs with term in title' do
            get path, headers: headers
            expect(JSON.parse(response.body)['data'].size).to be_eql 5
          end
        end
      end

      context 'term=<two letters>' do
        let!(:additional_programs) do
          5.times.map { |i| create(:program, title: "zz #{i}") }
        end

        include_examples 'programs index' do
          let(:term) { 'zz' }
          let(:path) { programs_path(term: term) }
        end

        include_examples 'programs index' do
          let(:term) { 'zz' }
          let(:path) { programs_path(term: term) }

          it 'returns only programs with term in title' do
            get path, headers: headers
            expect(JSON.parse(response.body)['data'].size).to be_eql 5
          end
        end
      end

      context 'term=<three letters>' do
        let!(:additional_programs) do
          5.times.map { |i| create(:program, title: "zzz #{i}") }
        end

        include_examples 'programs index' do
          let(:term) { 'zzz' }
          let(:path) { programs_path(term: term) }
          it 'returns only programs with term in title' do
            get path, headers: headers
            expect(JSON.parse(response.body)['data'].size).to be_eql 5
          end
        end
      end
    end
  end
end
