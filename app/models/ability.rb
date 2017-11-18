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
    end

    if user.present? && user.is_admin?
      can :manage, Card
      can :manage, Category
    end
  end
end
