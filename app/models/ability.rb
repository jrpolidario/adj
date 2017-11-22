class Ability
  include CanCan::Ability

  def initialize(user, player)
    # root page
    can :index, Game
    can :create, Player
    can :me, Session

    if player.present?
      can :manage, Player, id: player.id
      can :create, Game
      can :manage, GamesPlayer, player_id: player.id # a.k.a JoinGame
      can :create, Comment

      # if current turn, can flip the selectable card
      can :update, SelectableCard do |selectable_card|
        player.games_players.exists?(id: selectable_card.game.current_turn_games_player_id)
      end
    end

    if user.present? && user.is_admin?
      can :manage, Card
      can :manage, Category
    end
  end
end
