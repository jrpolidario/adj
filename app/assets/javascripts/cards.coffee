LiveRecord.Model.create(
  {
    modelName: 'Card'
    belongsTo: {
      category: { foreignKey: 'category_id', modelName: 'Category' }
    }
    hasMany: {
      selectableCards: { foreignKey: 'card_id', modelName: 'SelectableCard' }
    },
    instanceMethods: {
      imageUrl: ->
        if this.attributes.image
          '/uploads/card/image/' + this.id() + '/' + this.image()
      subimageUrl: ->
        if this.attributes.subimageUrl
          '/uploads/card/subimage/' + this.id() + '/' + this.subimage()
    }
  }
)
