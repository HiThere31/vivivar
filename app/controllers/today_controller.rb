class TodayController < ApplicationController
  def show
    @day = Day.today
    @mine = @day.moment_for(Current.user)
    @theirs = @day.moment_for(Current.user.partner)
    @streak = Day.current_streak
    @days_to_meet = days_to_meet
  end

  private
    def days_to_meet
      meet_on = Current.user.meet_on
      today = Time.zone.today
      (meet_on - today).to_i if meet_on && meet_on >= today
    end
end
