# Vue

1. [Estructura de la aplicación](#estructura-de-la-aplicación)
   1. [Packs](#packs)
   2. [Src](#src)
   3. [Components](#components)
2. [Uso básico](#uso-básico)

## Estructura de la aplicación

Debido a que se utilizará Webpack para manejar los JavaScript de la aplicación, el nuevo directorio para los mismos será `app/javascript`, el cual estará dividido en:
* [packs](#packs)
* [src](#src)
* [components](#components)

### Packs

Dentro de la carpeta de `packs` se encontrarán todos los archivos en los que se cargarán los JavaScript según la sección a la que correspondan, siguiendo el esquema de [micro frontend](https://micro-frontends.org/). Aquí se separarán según la sección del sitio web que se verán afectado; por ejemplo: dentro de `home.js` se encontrarán todos los archivos necesarios **únicamente** en la vista de home. 

### Src

Dentro de la carpeta `src` se encontrarán todos los archivos específicos que luego se cargarán dentro del correspondiente [pack](#packs). Estos archivos cumplirán funciones específicas, como por ejemplo, manejar la caja de productos o administrar los banners; de esta manera, se mantiene cada funcionalidad de la página en su archivo independiente, permitiendo esto utilizar ciertas funciones en específico en otras vistas sin la necesidad de importar otras que no serán utilizadas.

#### Ejemplo archivo vue.js

```javascript
import Vue from 'vue/dist/vue.esm'                    

document.addEventListener('DOMContentLoaded', () => {
  var app = new Vue({
    el: '#app',
    data: {
        message: 'hello!'
    }
  })
})
```

### Components 

Dentro de la carpeta `components` se encontrarán todos aquellos archivos que no sean correspondientes a JavaScript, como por ejemplo imágenes y estilos. En caso de que se quiera dejar de utilizar por completo el asset pipeline, es imperioso que **todos** los archivos correspondientes a estos tipos se encuentre dentro de dicha carpeta, ya que de otra forma no se compilarán y cargarán dentro de la plataforma.  
Según el esquema de las javascript-based apps, es necesario que todos los assets que se vayan a utilizar en conjunto a JavaScript (en este caso, vue.js) se encuentren dentro de esta carpeta. 

## Uso básico

> Para mayor información sobre el uso básico de vue.js, dirigirse a la [documentación oficial](https://vuejs.org/v2/guide/).