# Pantalla "Nosotros": cuenta regresiva, racha y ajustes
class UsController < ApplicationController
  def show
    @today = Time.zone.today
    @meet_on = Current.user.meet_on
    @progress = meet_progress
    @streak = Day.current_streak(@today)
    @best = [Day.best_streak, @streak].max
    @week = (@today.beginning_of_week(:monday)..@today.end_of_week(:monday)).to_a
    @revealed = Day.where(date: @week).where.not(revealed_at: nil).pluck(:date).to_set
  end

  # Actualiza el nombre propio, o la fecha para vernos (compartida entre los dos)
  def update
    params.key?(:name) ? update_name : update_meet_on
  end

  private
    def update_name
      name = params[:name].to_s.strip.first(30)

      if name.present? && Current.user.update(name: name)
        redirect_to us_path, notice: "Nombre guardado"
      else
        redirect_to us_path, alert: "Escribe tu nombre"
      end
    end

    def update_meet_on
      date = parse_date(params[:meet_on])

      if date && date >= Time.zone.today
        User.where(id: [Current.user.id, Current.user.partner_id].compact)
            .update_all(meet_on: date, meet_set_on: Time.zone.today, updated_at: Time.current)
        redirect_to us_path, notice: "Fecha guardada ✈️"
      else
        redirect_to us_path, alert: "Elige una fecha de hoy en adelante"
      end
    end
    def meet_progress
      return unless @meet_on && @meet_on >= @today

      set_on = Current.user.meet_set_on || @today
      total = (@meet_on - set_on).to_i
      return 100 if total <= 0

      (((@today - set_on).to_f / total) * 100).clamp(4, 100).round
    end

    def parse_date(value)
      Date.iso8601(value.to_s)
    rescue ArgumentError
      nil
    end
end
