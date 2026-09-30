class User < ApplicationRecord
  THEMES = %w[ella el].freeze

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :moments, dependent: :destroy
  has_many :push_subscriptions, dependent: :destroy
  belongs_to :partner, class_name: "User", optional: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :theme, inclusion: { in: THEMES }

  # Preferencias de los toggles en Nosotros
  def wants_push?(kind)
    case kind.to_sym
    when :upload then notify_uploads
    when :reveal, :reply then notify_reveals
    when :reminder then notify_reminder
    else true # thinking, test
    end
  end
end
