class Category < ApplicationRecord

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy
  has_many :cards

  def self.live_record_whitelisted_attributes(category, current_player)
    [:id, :name]
  end

  def self.live_record_queryable_attributes(current_player)
    []
  end
end
