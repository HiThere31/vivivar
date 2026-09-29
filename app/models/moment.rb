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

  # Al subir o responder: revela si ya están los dos y refresca la pantalla del otro
  after_commit :sync_day, on: %i[create update]

  private
    def photo_must_be_image
      return unless photo.attached?

      errors.add(:photo, "Tiene que ser una imagen") unless photo.content_type.to_s.start_with?("image/")
    end

    def sync_day
      day.reveal_if_complete!
      day.broadcast_refresh_later
    end
end
