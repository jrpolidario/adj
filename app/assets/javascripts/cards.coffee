LiveRecord.Model.create(
  {
    modelName: 'Card',
    plugins: {
      # remove this line if you're not using LiveDOM
      LiveDOM: true
    },

    ## More configurations below. See https://github.com/jrpolidario/live_record#example-1---model
    # belongsTo: {
    #   user: { foreignKey: 'user_id', modelName: 'User' }
    # },
    # hasMany: {
    #   books: { foreignKey: 'card_id', modelName: 'Book' }
    # },
    # callbacks: {
    #   'on:disconnect': [],
    #   'after:update': [],
    # }
  }
)
