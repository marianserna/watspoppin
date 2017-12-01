const environment = require('./environment');
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const merge = require('webpack-merge');

module.exports = merge({
  // used to ensure only 1 UglifyJsPlugin in final webpack array
  customizeArray: merge.unique(
    'plugins',
    ['UglifyJsPlugin'],
    plugin => plugin.constructor && plugin.constructor.name
  )
})(
  {
    plugins: [
      new UglifyJsPlugin({
        sourceMap: true,
        uglifyOptions: {
          compress: {
            warnings: false,
            comparisons: false
          }
        }
      })
    ]
  },
  environment.toWebpackConfig()
);
