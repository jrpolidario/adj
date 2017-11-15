class Ability
  include CanCan::Ability

  def initialize(player)
    # root page
    can :index, Game
    can :create, Player
    can :me, Session

    if player.present?
      can :manage, Player, id: player.id
      can :create, Game
      can :create, GamesPlayer # a.k.a JoinGame
    end
  end
end
