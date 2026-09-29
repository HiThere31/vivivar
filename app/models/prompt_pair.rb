class PromptPair < ApplicationRecord
  has_many :days, dependent: :restrict_with_error

  # Primero los pares que nunca han salido; cuando se acaban, cualquiera al azar
  def self.next_for_rotation
    unused = where.not(id: Day.select(:prompt_pair_id))
    unused.order(Arel.sql("RANDOM()")).first || order(Arel.sql("RANDOM()")).first
  end
end
