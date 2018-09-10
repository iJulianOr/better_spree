# Extensiones

> Para ver una extensión funcional, dirigirse a [spree_base_frontend](https://gitlab.web-experto.com.ar/spree-extensions/spree_base_frontend).

Según la nueva estructura de las aplicaciones en Spree, siguiendo las prácticas de WebExperto, se cambiará la manera de crear extensiones y administrar las configuraciones de las mismas dentro de la aplicación principal.

## Índice

1. [Creación](#creación)
2. [Generators](#generators)
   1. [Install](#install)
   2. [Templates](#templates)
3. [Javascript](#javascript)

## Creación

La creación seguirá siendo la básica:

```shell
spree extension name_of_extension
```

Una vez dentro del directorio de la extensión, será necesario crear el archivo `package.json` con el siguiente comando:

```shell
yarn init
# Instalar vue.js
yarn add vue --dev
```

Esto creará las dependencias necesarias para usar vue.js dentro de la extensión.

## Generators

Los generators cambiarán debido a que a partir de ahora, todos los archivos de JavaScript serán agregados dentro de un nuevo directorio (`app/javascript`) y se deberá agregar la correspondiente configuración de Webpack para que Webpacker pueda resolver el alias del directorio en el cual está instalada la gema. Es necesario que sea el path absoluto de la gema, debido a que es la forma en la que Webpack lo reconoce.

### Install

La estructura de `InstallGenerator` se mantendrá de la misma manera. Sólo se deberá agregar un nuevo método que será

```ruby
# Esta línea se encarga de indicar dónde se buscarán los templates que se utilizarán en la configuración de la app principal.
source_root File.expand_path('../../templates', __FILE__)
---
def add_webpack_config
  # Se agrega el require de la configuración al archivo environment.js de Webpack
  inject_into_file 'config/webpack/environment.js', "const nameOfExtension = require('./name_of_extension')\nenvironment.config.merge(nameOfExtension)\n",
    before: "module.exports = environment"
  # Se agrega la dependencia de la nueva extensión al archivo correspondiente de la aplicación principal
  # E.g.: en caso de que sea un estilo a utilizarse sólo en la home, se hará el append al archivo home.js en lugar de index.js 
  # Siendo este último el encargado de cargar los assets que son utilizados application-wide
  append_file 'app/javascript/packs/application.js', "import name_of_extension from '~name_of_extension/app/javascript/packs/index.js'\n"
  # Se copia el archivo de la extensión (en el directorio declarado en source_root) a la configuración de Webpack
  template 'name_of_extension.js', 'config/webpack/name_of_extension.js'
end
```

#### Ejemplo

```ruby
module SpreeBaseFrontend                                                                                                                                               
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      class_option :auto_run_migrations, type: :boolean, default: false
    
      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_base_frontend\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_base_frontend\n"
      end

      def add_webpack_config
        inject_into_file 'config/webpack/environment.js', "const spreeBaseFrontend = require('./spree_base_frontend')\nenvironment.config.merge(spreeBaseFrontend)\n", 
          before: "module.exports = environment"
        append_file 'app/javascript/packs/application.js', "import spree_base_frontend from '~spree_base_frontend/app/javascript/packs/index.js'\n"
        template 'spree_base_frontend.js', 'config/webpack/spree_base_frontend.js'
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_base_frontend\n", before: %r{\*\/}, verbose: true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_base_frontend\n", before: %r{\*\/}, verbose: true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_base_frontend'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
```

### Templates

Dentro de la carpeta `templates/` se creará un archivo llamado `name_of_extension.js` donde se agregarán todas las configuraciones correspondientes al directorio y/o dependencias de Node que se utilizarán en el proyecto principal.

```javascript
// child_process permite ejecutar comandos de unix
const execSync = require('child_process').execSync;
// Se guarda el path absoluto de la extensión
code = execSync('bundle show name_of_extension');

// Se exporta la configuración a Webpack
module.exports = {
  resolve: {
    alias: {
      // Se genera el alias del directorio de la extensión bajo el nombre de la misma
      // De manera que Webpacker pueda compilar los assets que allí se encuentran
      '~name_of_extension': code.toString().trim(),
    }
  }
}
```

## JavaScript

> Para ver la documentación sobre la estructura de los JavaScript, dirigirse a la [documentación de Vue](VUE.md).