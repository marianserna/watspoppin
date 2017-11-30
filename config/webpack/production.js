const environment = require('./environment');

const UglifyJSPlugin = require('uglifyjs-webpack-plugin');
const merge = require('webpack-merge');

module.exports = merge({
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
        compress: {
          warnings: false,
          comparisons: false // don't optimize comparisons
        }
      })
    ]
  },
  environment.toWebpackConfig()
);
