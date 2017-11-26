class SelectableCardsController < ApplicationController
  before_action :set_game, only: [:create, :index, :new] # shallow nested routes
  before_action :set_selectable_card, only: [:show, :edit, :update, :destroy]
  authorize_resource

  def create
    @selectable_card = @game.selectable_cards.new(selectable_card_params)

    respond_to do |format|
      if @selectable_card.save
        format.json { render :show, status: :created, location: @selectable_card }
      else
        format.json { render json: @selectable_card.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @selectable_card.update(selectable_card_params)
        if @selectable_card.persisted?
          format.json { render :show, status: :ok, location: @selectable_card }
        else
          format.json { render :show, status: :ok }
        end
      else
        format.json { render json: @selectable_card.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_selectable_card
    @selectable_card = SelectableCard.find(params[:id])
  end

  def selectable_card_params
    params.fetch(:selectable_card, {}).permit(:is_selected, :is_time_is_up, :team_winner)
  end
end
