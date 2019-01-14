# Galaxy of Drones Online Docker

[![Docker Pull Counter](https://img.shields.io/docker/pulls/galaxyofdrones/docker.svg)](https://hub.docker.com/r/galaxyofdrones/docker)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)

The dockerized version.

## Getting Started

Before you start, you need to install the prerequisites.

### Prerequisites

- Docker Engine: `Version >= 1.13` for building and running
- Docker Compose: for easy setup

### Run with Docker Compose



#### 1. Clone the repository:

```
git clone git@github.com:galaxyofdrones/docker.git
```

#### 2. Open the folder:

```
cd docker
```

#### 3. Pull the latest image

```
docker pull galaxyofdrones/docker:latest
```

#### 4. Start the containers

```
docker-compose up -d --no-build
```

#### 5. Open the game in your browser

*Note: If you don't see the page, please wait for initialization.*

```
http://localhost:8000
```

#### 6. Generate the starmap

*Estimated time: ~1 hour, Estimated size: ~4 GB*

```
docker-compose exec app php artisan starmap:generate
```

## License

The Galaxy of Drones Online Docker is licensed under the [MIT license](http://opensource.org/licenses/MIT).
