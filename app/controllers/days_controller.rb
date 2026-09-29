class DaysController < ApplicationController
  def show
    @day = Day.includes(:prompt_pair, moments: [:user, { photo_attachment: :blob }])
              .find_by(date: parse_date(params[:date]))

    return redirect_to(calendar_path, alert: "Ese día todavía no se revela") unless @day&.revealed?

    @mine = @day.moment_for(Current.user)
    @theirs = @day.moment_for(Current.user.partner)
  end

  private
    def parse_date(value)
      Date.iso8601(value.to_s)
    rescue ArgumentError
      nil
    end
end
