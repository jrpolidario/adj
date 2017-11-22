class Card < ApplicationRecord

  include LiveRecord::Model::Callbacks
  belongs_to :category
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  mount_uploader :image, CardImageUploader

  validates :category, presence: true
  validates :image, presence: true
  validates :name, presence: true

  def self.live_record_whitelisted_attributes(card, current_player)
    [:id, :name, :image, :category_id, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_player)
    [:category_id, :created_at, :updated_at]
  end
end
