const environment = require('./environment')
const merge = require('webpack-merge')
const autoprefixer = require('./autoprefixer')

module.exports = merge(
  environment.toWebpackConfig(),
  autoprefixer
)
