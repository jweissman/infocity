class PawnKey < ApplicationRecord
  belongs_to :pawn
  before_save :ensure_uuid_generated

  def ensure_uuid_generated
    if self.value.nil?
      logger.info "generate secure random uuid for pawn key"
      self.value = SecureRandom.uuid
    end
    true
  end
end
