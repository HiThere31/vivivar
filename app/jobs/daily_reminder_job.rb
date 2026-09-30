# Corre todos los días a las 8:00 p. m. (config/recurring.yml)
class DailyReminderJob < ApplicationJob
  queue_as :default

  def perform
    day = Day.today

    User.includes(:partner).find_each do |user|
      next if day.moment_for(user)

      body = if day.moment_for(user.partner)
        "#{user.partner.name} ya subió la suya 👀 Solo falta la tuya."
      else
        "Todavía no hay foto de hoy. ¿Empiezas tú?"
      end

      PushNotifier.deliver(user, kind: :reminder, title: "📷 Tu foto de hoy", body: body, path: "/moments/new", tag: "reminder")
    end
  end
end
