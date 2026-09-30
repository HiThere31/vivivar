namespace :push do
  desc "Genera las llaves VAPID y las guarda en credentials (solo si no existen)"
  task setup: :environment do
    credentials = Rails.application.credentials

    if credentials.dig(:vapid, :public_key).present?
      puts "✓ Las llaves VAPID ya existen"
      next
    end

    key = WebPush.generate_key
    data = YAML.safe_load(credentials.read.presence || "{}", aliases: true, permitted_classes: [Symbol, Date, Time]) || {}
    data["vapid"] = {
      "public_key" => key.public_key,
      "private_key" => key.private_key,
      "subject" => "mailto:#{User.find_by(theme: "el")&.email_address || "admin@example.com"}"
    }
    credentials.write(data.to_yaml)
    puts "✓ Llaves VAPID guardadas en config/credentials.yml.enc"
  end

  desc "Manda el recordatorio diario ahora (para probar)"
  task remind: :environment do
    DailyReminderJob.perform_now
    puts "✓ Recordatorio enviado a quien no ha subido su foto"
  end
end
