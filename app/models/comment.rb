class Comment < ApplicationRecord
  belongs_to :player

  include LiveRecord::Model::Callbacks
  has_many :live_record_updates, as: :recordable, dependent: :destroy

  def self.live_record_whitelisted_attributes(comment, current_user)
    [:id, :content, :player_id, :created_at, :updated_at]
  end

  def self.live_record_queryable_attributes(current_user)
    [:created_at]
  end
end
