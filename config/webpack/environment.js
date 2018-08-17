const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)
const spreeBaseFrontend = require('./spree_base_frontend')
environment.config.merge(spreeBaseFrontend)
module.exports = environment
