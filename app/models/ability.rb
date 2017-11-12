class Ability
  include CanCan::Ability

  def initialize(player)
    can :index, Game

    if player.present?
      can :manage, Player, id: player.id
    end
  end
end
