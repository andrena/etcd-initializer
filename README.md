# etcd-initializer

Example project to initialize an etcd docker container on startup with initial key-value pairs from a text file via docker-compose.

## Usage

* Start etcd container and load initial values: `docker-compose up -d --build`
* Retrieve all values from etcd container: `docker exec -it etcd-initializer_etcd_1 etcdctl get --prefix ""`

## Setup

Starting point of this project is the [docker-compose.yml](./docker-compose.yml): <br>
Here the main `etcd` service is set up as well as the `etcd-initializer`, which is only used to read out the key-value-pairs
from a (in out case) .properties file and write them into the main `etcd`. <br>

To achieve this, the `etcd-initializer` gets the content of the [etcd](./etcd) directory copied in the container
(done during build of the image as defined in the [Dockerfile](./etcd/Etcd-initializer.Dockerfile)) and then executes the script [load-default-values](./etcd/load-default-values.sh)
with a properties file as parameter. <br>
Since this is its only command the container stops after execution. <br>
*Important:* After the first build, use `docker-compose up -d --build` in order to have changes in the [properties file](./etcd/initial-values-local.properties)
reflected in the container.

The script [load-default-values](./etcd/load-default-values.sh) only reads the key-value-pairs from the properties file specified in the docker-compose
and writes the into the main `etcd` via `etcd put <key> <value>`.

In a productive setup, you would probably have a separate compose file per environment, where you would specify separate .properties files.

### Reasoning for second etcd container
The main `etcd` container needs to be started in order to run scripts like `etcd put <key> <value>`. <br>
Etcd itself does not support loading initial values from a file
(see [feature request](https://github.com/etcd-io/etcd/issues/8702) for reference). <br>
To make sure that the main `etcd` is ready to accept connections, it seemed to be the easiest and most maintainable way
to start a second `etcd` container, since it is small, fast in startup and already brings all necessary functionality.

## Contribution

Contributions via pull requests are very welcome, e.g. for supporting Json files.