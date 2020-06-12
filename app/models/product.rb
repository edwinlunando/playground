class Product < ApplicationRecord

  def self.update_all(updates)
    # updates_with_timestamp = updates.merge({ updated_at: Time.zone.now })
    # super(updates_with_timestamp)
    updates["updated_at"] = Time.zone.now
    super
  end

end
