class Moment < ApplicationRecord
  belongs_to :user
  belongs_to :day

  has_one_attached :photo do |attachable|
    attachable.variant :display, resize_to_limit: [1080, 1080], format: :jpeg, saver: { quality: 82 }
    attachable.variant :thumb, resize_to_fill: [96, 96], format: :jpeg
  end

  validates :photo, presence: { message: "Toma una foto" }
  validates :caption, presence: { message: "Escribe unas palabras" },
                      length: { maximum: 80, message: "Máximo 80 caracteres" }
  validates :reply, length: { maximum: 80 }
  validates :user_id, uniqueness: { scope: :day_id, message: "Ya subiste tu foto de hoy" }
  validate :photo_must_be_image

  # Al subir: revela si ya están los dos, avisa por push y refresca la pantalla del otro
  after_create_commit :announce_upload
  after_update_commit :announce_reply, if: :saved_change_to_reply?

  private
    def photo_must_be_image
      return unless photo.attached?

      errors.add(:photo, "Tiene que ser una imagen") unless photo.content_type.to_s.start_with?("image/")
    end

    def partner
      user.partner
    end

    def announce_upload
      if day.reveal_if_complete!
        [ user, partner ].compact.each do |person|
          other = person.partner
          push(person, :reveal, "💞 Se revelaron las fotos de hoy", "Mira lo que subió #{other&.name}.")
        end
      elsif partner && !day.revealed?
        push(partner, :upload, "👀 #{user.name} ya subió su foto", "Sube la tuya para verla.")
      end

      day.broadcast_refresh_later
    end

    def announce_reply
      return if reply.blank?

      push(partner, :reply, "💬 #{user.name} respondió a tu foto", "«#{reply}»") if partner
      day.broadcast_refresh_later
    end

    def push(person, kind, title, body)
      PushNotificationJob.perform_later(person, kind.to_s, title, body, "/", "day-#{day_id}")
    end
end
