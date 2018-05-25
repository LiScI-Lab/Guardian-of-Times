require 'rails_helper'

RSpec.describe Team::Member, type: :model do
  it "has a team and a user" do
    member = create(:member)
    expect(member.user).not_to be_nil
    expect(member.team).not_to be_nil
  end

  context "with progresses" do
    before(:example) do
      @member = create(:member)
      progresses = [:progress_month_before,
                    :progress_start_of_month,
                    :progress_end_of_month,
                    :progress_month_after].map { |sym| create(sym, member: @member, team: @member.team) }

      @member.progresses << progresses
      @member.save!
    end

    it "have progresses" do
      expect(Team::Member.find(@member.id).progresses.length).to eq(4)
    end

    it "calculates the total spend time" do
      expect(@member.total_time_spend).to eq(2.hours*4)
    end
    it "calculates the spend time in current month" do
      expect(@member.current_month_time_spend).to eq(2.hours*2)
    end
  end

  context "with unavailabilities" do
    it "should be available" do
      member = create(:member)
      member.unavailabilities << [:tomorrow_unavailability, :yesterday_unavailability].map { |u| build(u, team: member.team, member: member) }
      member.save!
      expect(member.current_unavailability).to be_nil
      expect(member.available?).to be_truthy
    end
    it "should not be available" do
      member = create(:member)
      unavailabiliy = build(:current_unavailability, team: member.team, member: member)
      member.unavailabilities << unavailabiliy
      member.save!

      expect(member.current_unavailability).to eq(unavailabiliy)
      expect(member.available?).to be_falsey
    end
  end
end
