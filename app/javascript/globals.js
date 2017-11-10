export function currentPlayer() {
  const playerAttributes = this.$session.get('currentPlayerAttributes')
  let player = LiveRecord.Model.all.Player.all[playerAttributes.id]

  // if player not yet in store, retrieve player from backend
  if (!player) {
    player = new LiveRecord.Model.all.Player(playerAttributes)
    player.create({reload: true})
  }

  return player
}
