class PushNotificationJob < ApplicationJob
  queue_as :default

  def perform(user, kind, title, body, path = "/", tag = nil)
    PushNotifier.deliver(user, kind: kind.to_sym, title: title, body: body, path: path, tag: tag)
  end
end
