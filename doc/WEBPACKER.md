# Webpacker

Webpacker facilita el uso de Webpack para manejar los JavaScript en Rails. El mismo coexiste con el asset pipeline, ya que el propósito principal de Webpack es el JavaScript de las aplicaciones, no imágenes, CSS o incluso JavaScript Sprinkles; todos ellos continuan estando en app/assets.  

# Índice

1. [Configuración](#configuracion)  
   1. [Configuración de entorno actual](#configuración-de-entorno-actual)  
   2. [Configuración desde cero](#configuración-desde-cero)
      3. [Webpack 4](#webpack-4) 
2. [Uso](#uso)
2. [Webpack](#webpack)  
   1. [Environment](#environment)  
      1. [Plugins](#plugins)  
      2. [Configuraciones](#configuraciones)  
   2. [Development](#development)  
   3. [Production](#production)
2. [Templates](#templates)  
   1. [Archivo de configuración](#archivo-de-configuración)
   2. [Configuración de una extensión](#configuración-de-una-extensión)

# Configuración

## Configuración de entorno actual

Los archivos actuales de configuración ya están armados, sólo se deben instalar las dependencias:
```bash
yarn install
```

**NOTA IMPORTANTE: No ejecutar el comando `bundle exec rails webpacker:install` ya que actualizará versiones del package.json que son necesarias en versiones más nuevas que las soportadas por Webpacker. Siempre utilizar `yarn install`.**

## Configuración desde cero

La instalación básica temporal de Webpacker deberá ser usando las siguientes versiones:

```ruby
gem 'webpacker', '>= 4.0.x'
```
```bash
yarn add @rails/webpacker@4.0.0-pre.2
```

Instalar la gema y correr la instalación:

```rails
bundle
bundle exec rails webpacker:install
```

Para solucionar problemas de compatibilidad, correr el siguiente comando:

```
yarn upgrade
```

### Webpack 4

Para utilizar Webpack 4 será necesario ejecutar el siguiente comando:

```shell
yarn add webpack --dev 
yarn upgrade
```

Y **no volver a ejectuar `rails webpacker:install`** ya que actualizará el paquete y lo volverá a la versión 3.5, siendo esta la última soportada por Webpacker actualmente.

# Uso

Los conceptos básicos para utilizar Webpacker serán:  
1. [Compilado](#compilado)  
   Mismo concepto que `rails assets:precompile`  
2. [Instalación de plugins](#instalación-de-plugins)  
   Mismo concepto que `gem install`

## Compilado

Cumple la misma funcion que `rails assets:precompile` sólo que en lugar de correr sobre Sprockets, correrá sobre Webpack, siendo este último quien se encargue de realizar el precompilado, minimización y compresión de assets.  
Para compilar assets será necesario correr el comando `rails webpacker:compile`, que reemplazará a `rails assets:precompile`. 

## Instalación de plugins

Para instalar plugins relacionados a Webpack, como por ejemplo Vue, será necesario correr el siguiente comando

```rails
bundle exec rails webpacker:install:vue
```

Reemplazando :vue por cualquiera de los plugins soportados por Webpacker. Actualmente:

* React
* Angular
* Elm
* Stimulus
* Coffeescript
* Erb

# Webpack

## Environment

Es el archivo donde se cargarán todas las configuraciones de Webpack, indiferentemente del environment en que se esté trabajando. El mismo es creado por defecto con la instalación de Webpack y ya trae las configuraciones necesarias para trabajar con Vue y Babel. Tal y como vimos en [Instalación de plugins](#instalación-de-plugins), será posible agregar una serie de plugins de Webpack de manera automática con Webpacker. Para los que no sean soportados será necesario ver la sección [Plugins](#plugins) a continuación.

### Plugins

La estructura básica para agregar un plugin es:
```javascript
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
```

### Configuraciones

Para agregar una configuración será recomendable crear un archivo nuevo exclusivamente para la misma. Supongamos que se creará una configuración para la gema encargada de manejar el frontend (en este caso spree_base_frontend), se deberá crear un archivo de nombre `spree_base_frontend.js` con la siguiente configuración de ejemplo dentro:

```javascript
// Child process ejecuta comandos de unix
const execSync = require('child_process').execSync;
// Este comando arroja el path donde está instalada la gema  
code = execSync('bundle show spree_base_frontend');

module.exports = {
  resolve: {
    // Se agrega una alias con dicho path a la configuración de Webpack
    alias: {
      '~spree_base_frontend': code.toString().trim(),
    }
  }
}
```

Y luego se agregarán las siguientes líneas dentro del archivo `environment.js`:
```javascript
// Carga la configuración de spree_base_frontend
const spreeBaseFrontend = require('./spree_base_frontend')
// Une la configuración de spree_base_frontend.js con la general de Webpack
environment.config.merge(spreeBaseFrontend)
```

## Development

Actualmente se utiliza el archivo generado por defecto por Webpacker:

```javascript
process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
```

## Production

Al igual que en development, se utiliza el archivo generado por defecto por Webpacker:

```javascript
process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()
```

# Templates

## Archivo de configuración

```yaml
# Note: You must restart bin/webpack-dev-server for changes to take effect 

default: &default
  source_path: app/javascript
  source_entry_path: packs
  public_output_path: packs
  cache_path: tmp/cache/webpacker

  # Additional paths webpack should lookup modules
  # ['app/assets', 'engine/foo/app/assets']
  resolved_paths: []

  # Reload manifest.json on all requests so we reload latest compiled packs
  cache_manifest: false

  extensions:
    - .erb
    - .vue
    - .js
    - .js.erb
    - .sass
    - .scss
    - .css
    - .module.sass
    - .module.scss
    - .module.css
    - .png
    - .svg
    - .gif
    - .jpeg
    - .jpg

development:
  <<: *default
  compile: true

  # Reference: https://webpack.js.org/configuration/dev-server/
  dev_server:
    https: false
    host: localhost
    port: 3035
    public: localhost:3035
    hmr: false
    # Inline should be set to true if using HMR
    inline: true
    overlay: true
    compress: true
    disable_host_check: true
    use_local_ip: false
    quiet: false
    headers:
      'Access-Control-Allow-Origin': '*'
    watch_options:
      ignored: /node_modules/

```

## Configuración de una extensión

> Para mayor información sobre cómo realizar una extensión ver la [documentación de extensiones](./EXTENSIONS.md).

Dentro del directorio `lib/generators/name_of_extension/templates` crear un archivo llamado `name_of_extension.js` que será el que se copiará a la aplicación principal al momento de la instalación:

```javascript
const execSync = require('child_process').execSync;  
code = execSync('bundle show name_of_extension');

module.exports = {
  resolve: {
    alias: {
      '~spree_base_frontend': code.toString().trim(),
    }
  }
}
```