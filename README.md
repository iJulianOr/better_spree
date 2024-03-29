# README

# Índice

1. [Uso básico](#uso-básico)  
   1. [Instalación](#instalación)
      1. [Con Docker](#con-docker)
      2. [Sin Docker](#sin-docker)
         1. [Ruby](#ruby)  
         2. [Git](#git)  
         3. [Node](#node)  
         4. [Rails](#rails)  
         5. [Psql](#psql)  
   2. [Levantar la aplicación](#levantar-la-aplicación)  
      1. [Iniciar con Docker](#iniciar-con-docker)
      1. [Iniciar sin Docker](#iniciar-sin-docker)
2. [Dependencias básicas](#dependencias-básicas)  
   1. [Foreman](#foreman)  
   2. [Webpacker](#webpacker)  
      1. [Compilado](#compilado)  
      2. [Instalación de plugins](#instalación-de-plugins)  

# Uso básico

## Instalación

Lo primero será clonar el repositorio en el directorio de preferencia 

```shell
git clone git@gitlab.web-experto.com.ar:spree/spree_base.git
```

### Con Docker

> Requisitos: Tener instalado Docker. Seguir el tutorial de la página de docker (https://docs.docker.com/engine/installation/). Instalar Docker-compose (https://docs.docker.com/compose/install/).

| Dependencia    | Versión         |
| -----------    | :-------------: |
| Docker         | 17.12.1-ce      |
| Docker-compose | 1.21.2          |

Buildear el proyecto

```shell
docker-compose -f <entorno>.yml build
```

Crear la base de datos

```shell
docker-compose -f <entorno>.yml run --rm web rails db:create db:migrate db:seed spree_sample:load
```

Levantar el proyecto

```shell
docker-compose -f <entorno>.yml up
```

### Sin Docker

| Dependencia | Versión         |
| ----------- | :-------------: |
| Ruby        | 2.5.1p57        |
| Rails       | 5.2.0           |
| Foreman     | 0.85.0          |
| Bundler     | 1.16.3          |
| Webpacker   | 4.0.0.pre.pre.2 |
| Webpack     | 4.17.2          |
| Vue         | 2.5.17          |
| Babel       | 5.0.0           |

#### Ruby

> Para mayor información sobre el uso de Ruby, ver la [documentación de Ruby](doc/RUBY.md).

Para validar que estén las dependencias necesarias para Webpacker, será necesario ejecutar los siguientes comandos: 

```shell
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn
```

Instalación usando RVM:

```shell
sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.5.1
rvm use 2.5.1 --default
ruby -v
```

Instalación de bundler (gema para manejar versiones dentro de aplicaciones de Rails):
```shell
gem install bundler
```

#### Git

> Para mayor información sobre el uso de Git, ver la [documentación de Git](doc/GIT.md).

Configuración básica de git:

```shell
git config --global color.ui true
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR@EMAIL.com"
ssh-keygen -t rsa -b 4096 -C "YOUR@EMAIL.com"
```

Agregar la key generada previamente al perfil de Gitlab en https://gitlab.web-experto.com.ar/profile/keys copiando el resultado del siguiente comando:
```shell
cat ~/.ssh/id_rsa.pub
```

#### Node

> Para mayor información sobre el uso de Node, ver la [documentación de Node](doc/NODE.md).

Es necesario instalar Node para manejar los paquetes de Webpack.  
Para hacerlo, ejecutar los siguientes comandos:
```shell
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Rails

> Para mayor información sobre el uso de Rails, ver la [documentación de Rails](doc/RAILS.md).

La instalación de Rails es igual a la de bundler (al ser ambas una gema):

```shell
gem install rails -v 5.2.0
```

#### Psql

La base de datos a utilizar estará hecha bajo Psql. Para su instalación, ejecutar los siguientes comandos en la terminal:

```shell
sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common
sudo apt-get install postgresql-9.5 libpq-dev
```

Por defecto, la instalación de Psql no crea un usuario. Para ello, será necesario ejecutar el siguiente comando:
```shell
sudo -u postgres createuser root -s
```

### Package.json

Para instalar las dependencias de Node será necesario ejecutar

```bash
yarn install
yarn add webpack --dev 
yarn upgrade
```

## Levantar la aplicación

Para levantar la aplicación sólo será necesario correr el comando `foreman start`

# Dependencias básicas

## Foreman

Foreman se encarga de manejar procesos dentro de archivos Procfile. En este caso, la aplicación dejará de correr **sólo** bajo el comando `rails s`, y comenzará a ser necesario también correr el comando `webpack-dev-server` (en desarrollo) o `NODE_ENV=production ./bin/webpack --watch --colors --progress` (en producción). 
Para esto, se crea un archivo Procfile con la siguiente configuración:
```
backend: bin/rails s -p 3000    
frontend: bin/webpack-dev-server
```

La explicación de esto, es que Rails ahora se encargará de de los procesos backend del servidor (consultas, redirecciones, etcétera) y Webpack de los procesos frontend (precompilado de assets, compresión, etcétera). 

Dentro de la aplicación, en la carpeta /bin encontraremos un archivo llamado `webpack-dev-server` que es donde se encuentran los comandos ejecutados para levantar el servicio de Webpack según las dependencias y argumentos de Webpacker (archivo utilizado en el comando de frontend del Procfile).

## Webpacker

> Para mayor información sobre el uso de Webpacker, ver la [documentación de webpacker](doc/WEBPACKER.md).

Webpacker es la gema encargada del manejo de assets dentro de la aplicación, siendo el reemplazo del asset pipeline en todo lo referente a JavaScript.  
Ésta incluye un nuevo directorio dentro de `app/`, llamado `javacript/`, donde se guardarán los nuevos archivos de assets.  
