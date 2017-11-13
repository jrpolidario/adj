class Player < ApplicationRecord
  
  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  validates :name, presence: true, length: { maximum: 12 }

  def self.live_record_whitelisted_attributes(player, current_user)
    [:id, :name, :game_id, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:id, :name, :game_id, :created_at, :updated_at]
  end
end
