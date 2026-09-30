class Day < ApplicationRecord
  belongs_to :prompt_pair
  has_many :moments, dependent: :destroy

  validates :date, presence: true

  # El día de hoy (zona America/Costa_Rica). Lo crea con un prompt nuevo si no existe.
  def self.today
    date = Time.zone.today
    find_by(date: date) || create_or_find_by!(date: date) do |day|
      day.prompt_pair = PromptPair.next_for_rotation
    end
  end

  def self.revealed_dates
    where.not(revealed_at: nil).order(:date).pluck(:date)
  end

  # Días seguidos revelados, contando hoy si ya se reveló (si no, desde ayer)
  def self.current_streak(today = Time.zone.today)
    dates = revealed_dates.to_set
    cursor = dates.include?(today) ? today : today - 1
    streak = 0
    while dates.include?(cursor)
      streak += 1
      cursor -= 1
    end
    streak
  end

  def self.best_streak
    best = run = 0
    previous = nil
    revealed_dates.each do |date|
      run = previous && date == previous + 1 ? run + 1 : 1
      best = [best, run].max
      previous = date
    end
    best
  end

  def revealed?
    revealed_at.present?
  end

  def moment_for(user)
    return unless user

    moments.detect { |moment| moment.user_id == user.id }
  end

  # Ella recibe prompt_a, él recibe prompt_b
  def prompt_for(user)
    user&.theme == "el" ? prompt_pair.prompt_b : prompt_pair.prompt_a
  end

  # Devuelve true solo a quien efectivamente reveló (evita avisos dobles si suben al mismo tiempo)
  def reveal_if_complete!
    return false if revealed? || moments.count < 2

    won = Day.where(id: id, revealed_at: nil).update_all(revealed_at: Time.current, updated_at: Time.current) == 1
    reload if won
    won
  end
end
