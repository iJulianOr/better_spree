const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const { VueLoaderPlugin } = require('vue-loader')
const vue =  require('./loaders/vue')

const webpack = require('webpack')

environment.plugins.append(
  'CommonsChunkVendor',
  new webpack.optimize.SplitChunksPlugin({
    name: 'vendor',
    minChunks: (module) => {
      // this assumes your vendor imports exist in the node_modules directory
      return module.context && module.context.indexOf('node_modules') !== -1
    }
  })
)

environment.plugins.append(
  'CommonsChunkManifest',
  new webpack.optimize.SplitChunksPlugin({
    name: 'manifest',
    minChunks: 2
  })
)

environment.config.merge({
    optimization: {
        minimize: true
    }
})
//environment.plugins.append(
//    'UglifyJs',
//    new webpack.optimize.UglifyJsPlugin({
//        compressor: { warnings: false },
//        sourceMap: false
//    })
//)

const spreeBaseFrontend = require('./spree_base_frontend')
environment.config.merge(spreeBaseFrontend)

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue', vue)
environment.loaders.append('erb', erb)
module.exports = environment
