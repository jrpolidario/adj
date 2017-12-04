module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['postcss-loader']
      }
    ]
  },
  plugins: [
    require('autoprefixer')
  ]
}
