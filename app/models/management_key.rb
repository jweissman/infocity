class ManagementKey < ApplicationRecord
  belongs_to :space

  before_save :ensure_uuid_generated

  def ensure_uuid_generated
    if self.value.nil?
      logger.info "generate secure random uuid for mgmt key"
      self.value = SecureRandom.uuid
    end
    true
  end
end
