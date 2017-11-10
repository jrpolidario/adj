<template>
  <section id='show-game' class='full-height'>
    <div class='row full-height collapse'>
      <div class='small-12 medium-6 medium-centered columns full-height'>
        <div class='row full-height collapse'>
          <Card v-for='card in cards' :card='card'/>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
  import Card from './show/cards/Card'

  let nextCardId = 1

  export default {
  	components: { Card },
    data () {
      return {
        cards: [
  				{
  					id: nextCardId++,
  					name: 'Dog',
            image_url: '/categories/animals/dog.jpg',
            category: {
              name: 'Animal'
            }
  				},
  				{
            id: nextCardId++,
  					name: 'Cat',
            image_url: '/categories/animals/cat.jpg',
            category: {
              name: 'Animal'
            }
  				},
  				{
            id: nextCardId++,
  					name: 'Mouse',
            image_url: '/categories/animals/mouse.jpg',
            category: {
              name: 'Animal'
            }
  				},
          {
            id: nextCardId++,
  					name: 'Pig',
            image_url: '/categories/animals/pig.jpg',
            category: {
              name: 'Animal'
            }
  				}
        ]
      }
    }
  }
</script>

<style lang='scss' scoped>
  #show-game {
    padding-top: 10%;
    padding-bottom: 10%;
  }
</style>
