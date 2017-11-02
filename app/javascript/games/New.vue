<template>
  <div id='new-game'>
    <div class='row'>
      <div class='small-12 medium-6 medium-centered columns'>
        <div class='row'>
          <Card v-for='card in cards' :card='card'/>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Card from './cards/Card'

let nextCardId = 1

export default {
	components: { Card },
  data () {
    return {
      cards: [
				{
					id: nextCardId++,
					name: 'Dog'
				},
				{
          id: nextCardId++,
					name: 'Cat'
				},
				{
          id: nextCardId++,
					name: 'Mouse'
				},
        {
          id: nextCardId++,
					name: 'Pig'
				}
      ]
    }
  }
}
</script>

<style lang='scss' scoped>
#new-game {
  background: #ccf;
}
</style>
