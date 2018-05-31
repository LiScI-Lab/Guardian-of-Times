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

  context "with target_hours" do
    before(:example) do
      @member = create(:member)
      @member.target_hours << [Team::Member::TargetHour.new(since: Date.today-1.month, hours: 20), Team::Member::TargetHour.new(since: Date.today-3.month, hours: 40)]
      @member.save!
    end

    it "should have target_hours, sorted by `since` date" do
      expect(@member.target_hours.length).to eq(2)
      expect(@member.target_hours.last.since).to eq(Date.today-1.month)
      expect(@member.target_hours.last.hours).to eq(20)
    end
    it "should return the matching target_hours for a date" do
      expect(@member.matching_target_hours(Date.today)).to eq(20)
      expect(@member.matching_target_hours(Date.today-2.month)).to eq(40)
    end
    it "should return 0 hours for unkown timespan" do
      expect(@member.matching_target_hours(Date.today-2.years)).to eq(0)
    end
    it "should calculate extra hours as difference of progresses-target_hours" do
      month = DateTime.now.beginning_of_month
      progresses = (0...20).map { |n| Team::Progress.new(member: @member, team: @member.team, start: month+n.days, end: month+n.days+4.hours) }
      #expected_extra_hours = (progresses.map { |p| p.time_spend }.sum/3600 - 20) #20 = target_hours of `month`
      expected_extra_hours = (4*20 - 20) #20 = target_hours of `month`
      @member.progresses << progresses
      @member.save!

      expect(@member.extra_hours(month)).to eq(expected_extra_hours)
    end
  end
end
