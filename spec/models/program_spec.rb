require 'rails_helper'

RSpec.describe Program, type: :model do
  subject { create(:program) }

  describe '#subscriptions_count' do
    it 'increment subscriptions_count on related Subscription creation' do
      subject.subscriptions.create!(user: create(:user))
      expect(subject.reload.subscriptions_count).to be_eql 1
    end

    it 'decrement subscriptions_count on related Subscription deletion' do
      3.times { subject.subscriptions.create!(user: create(:user)) }
      expect(subject.reload.subscriptions_count).to be_eql 3
      subject.subscriptions.last.destroy
      expect(subject.reload.subscriptions_count).to be_eql 2
    end

    it "doesn't change subscriptions_count on update" do
      subscriptions_count = subject.subscriptions_count
      subject.update(subscriptions_count: subscriptions_count + 1)
      expect(subject.reload.subscriptions_count).to be_eql(subscriptions_count)
    end
  end

  describe '#popular' do
    let(:programs) { create_list(:program, 3) }
    let(:subscriptions) do
      build_list(:subscription, 2) do |s|
        s.program = programs.first
      end + build_list(:subscription, 1) do |s|
        s.program = programs.last
      end
    end

    it 'returns programs ordered by subscriptions_count' do
      subscriptions.map(&:save)
      ordered_counts = Program.popular.map(&:subscriptions_count)
      expect(ordered_counts).to be_eql([2, 1, 0])
    end
  end
end
