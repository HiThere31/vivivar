# Envía notificaciones Web Push a todos los dispositivos de un usuario.
# Llaves VAPID: credentials (vapid.public_key / private_key / subject) o ENV.
class PushNotifier
  class << self
    def public_key
      Rails.application.credentials.dig(:vapid, :public_key) || ENV["VAPID_PUBLIC_KEY"]
    end

    def configured?
      public_key.present? && private_key.present?
    end

    # kind: :upload | :reveal | :reply | :reminder | :thinking | :test
    def deliver(user, kind:, title:, body:, path: "/", tag: nil)
      return unless configured? && user&.wants_push?(kind)

      message = { title: title, body: body, path: path, tag: tag }.compact.to_json

      user.push_subscriptions.find_each do |subscription|
        WebPush.payload_send(
          message: message,
          endpoint: subscription.endpoint,
          p256dh: subscription.p256dh,
          auth: subscription.auth,
          vapid: vapid,
          ttl: 12.hours.to_i
        )
      rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription
        subscription.destroy # el teléfono ya no acepta esta suscripción
      rescue WebPush::ResponseError, SocketError, Timeout::Error, Errno::ECONNREFUSED => e
        Rails.logger.warn("[push] #{user.name}: #{e.class} #{e.message}")
      end
    end

    private
      def private_key
        Rails.application.credentials.dig(:vapid, :private_key) || ENV["VAPID_PRIVATE_KEY"]
      end

      def vapid
        {
          subject: Rails.application.credentials.dig(:vapid, :subject) || ENV.fetch("VAPID_SUBJECT", "mailto:admin@example.com"),
          public_key: public_key,
          private_key: private_key
        }
      end
  end
end
