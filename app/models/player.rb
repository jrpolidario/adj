class Player < ApplicationRecord
  belongs_to :game, required: false

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  validates :name, presence: true, length: { maximum: 15 }

  def self.live_record_whitelisted_attributes(player, current_user)
    # Add attributes to this array that you would like current_user to have access to.
    # Defaults to empty array, thereby blocking everything by default, only unless explicitly stated here so.
    [:name, :game_id, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:name, :game_id, :created_at, :updated_at]
  end
end
