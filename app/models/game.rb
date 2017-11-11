class Game < ApplicationRecord

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :players, dependent: :destroy
  accepts_nested_attributes_for :players

  def self.live_record_whitelisted_attributes(game, current_user)
    [:name, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:name, :created_at, :updated_at]
  end
end
