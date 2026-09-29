class CalendarController < ApplicationController
  def index
    @today = Time.zone.today
    @month = parse_month(params[:month]) || @today.beginning_of_month
    @month = @today.beginning_of_month if @month > @today.beginning_of_month

    @days = Day.where(date: @month.all_month)
               .includes(moments: [:user, { photo_attachment: :blob }])
               .index_by(&:date)
    @month_count = @days.values.count(&:revealed?)
  end

  private
    def parse_month(value)
      Date.strptime(value.to_s, "%Y-%m")
    rescue ArgumentError
      nil
    end
end
