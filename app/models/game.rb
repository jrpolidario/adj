class Game < ApplicationRecord

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :players
  accepts_nested_attributes_for :players

  def self.live_record_whitelisted_attributes(game, current_user)
    # Add attributes to this array that you would like current_user to have access to.
    # Defaults to empty array, thereby blocking everything by default, only unless explicitly stated here so.
    []
  end
end
