<template>
  <div id='card-select' class='full-height'>
    <Card
      v-for='position in positions'
      :game='game'
      :position='position'
    />
  </div>
</template>

<script>
  import Card from './card_select/Card'

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
        positions: [1, 2, 3, 4]
        // cards: [
  			// 	{
  			// 		name: 'Dog',
        //     image_url: '/categories/animals/dog.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	},
  			// 	{
  			// 		name: 'Cat',
        //     image_url: '/categories/animals/cat.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	},
  			// 	{
  			// 		name: 'Mouse',
        //     image_url: '/categories/animals/mouse.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	},
        //   {
  			// 		name: 'Pig',
        //     image_url: '/categories/animals/pig.jpg',
        //     category: {
        //       name: 'Animal'
        //     }
  			// 	}
        // ]
      }
    }
  }
</script>

<style lang='scss' scoped>
</style>
