class Game < ApplicationRecord

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :games_players, dependent: :destroy
  accepts_nested_attributes_for :players

  scope :ongoing, -> { where.has{ (updated_at > 1.minute.ago) & (is_finished == false) } }

  def self.live_record_whitelisted_attributes(game, current_user)
    # only allow fetching of ongoing records
    if ongoing.exists?(id: game.id)
      [:id, :is_finished, :name, :created_at, :updated_at]
    else
      []
    end
  end

  def self.live_record_queryable_attributes(current_user)
    [:is_finished, :updated_at]
  end
end
