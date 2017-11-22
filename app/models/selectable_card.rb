class SelectableCard < ApplicationRecord
  belongs_to :game
  belongs_to :card

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  def self.live_record_whitelisted_attributes(selectable_card, current_user)
    [:id, :card_id, :game_id, :position, :is_front_side_up, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:game_id, :card_id, :created_at, :updated_at]
  end
end
