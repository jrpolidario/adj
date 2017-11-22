class SelectableCardsController < ApplicationController
  before_action :set_game
  authorize_resource

  def take_from_deck

  end
end
