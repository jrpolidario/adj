<template>
  <div id='card-select' class='full-height'>
    <Card v-if='game && game.attributes.is_started' v-for='card in cards' :card='card'/>
  </div>
</template>

<script>
  import Card from './cards/Card'

  export default {
    components: { Card },
    props: {
      game: {
        type: Object,
        required: true
      }
    },
    data() {
      return {
        cards: [
  				{
  					name: 'Dog',
            image_url: '/categories/animals/dog.jpg',
            category: {
              name: 'Animal'
            }
  				},
  				{
  					name: 'Cat',
            image_url: '/categories/animals/cat.jpg',
            category: {
              name: 'Animal'
            }
  				},
  				{
  					name: 'Mouse',
            image_url: '/categories/animals/mouse.jpg',
            category: {
              name: 'Animal'
            }
  				},
          {
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
</style>
