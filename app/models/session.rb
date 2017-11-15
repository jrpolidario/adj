class Session < ApplicationRecord

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  def self.live_record_whitelisted_attributes(session, current_user)
    []
  end

  def self.live_record_queryable_attributes(current_user)
    []
  end
end
