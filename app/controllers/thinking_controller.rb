# Botón "Pensando en ti 💭"
class ThinkingController < ApplicationController
  rate_limit to: 5, within: 10.minutes, only: :create,
             with: -> { redirect_to us_path, alert: "Ya le avisaste, dale un ratito 💭" }

  def create
    partner = Current.user.partner
    return redirect_to(us_path) unless partner

    PushNotificationJob.perform_later(partner, "thinking", "💭 #{Current.user.name} está pensando en ti", "Justo ahora.", "/", "thinking")
    redirect_to us_path, notice: "Le avisamos a #{partner.name} 💭"
  end
end
