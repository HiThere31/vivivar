class PushSubscriptionsController < ApplicationController
  # Guarda (o reasigna) la suscripción de este dispositivo
  def create
    data = params.expect(subscription: [ :endpoint, { keys: %i[p256dh auth] } ])

    subscription = PushSubscription.find_or_initialize_by(endpoint: data[:endpoint])
    subscription.update!(user: Current.user, p256dh: data.dig(:keys, :p256dh), auth: data.dig(:keys, :auth))

    head :created
  end

  # Botón "Enviar prueba" en Nosotros
  def test
    if Current.user.push_subscriptions.none?
      redirect_to us_path, alert: "Primero activa las notificaciones en este teléfono"
    else
      PushNotifier.deliver(Current.user, kind: :test, title: "🔔 Prueba", body: "Si ves esto, las notificaciones funcionan.", tag: "test")
      redirect_to us_path, notice: "Prueba enviada 📬"
    end
  end
end
