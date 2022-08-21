terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.20"
    }
  }
}

provider "docker" {}

resource "docker_image" "image" {
  name = "yeasy/simple-web:latest"
}

resource "random_string" "random" {
  length  = 4
  count   = 2
  upper   = false
  special = false
}

resource "docker_container" "containers" {
  count = 2
  name  = join("-", ["simply", random_string.random[count.index].result, count.index])
  image = docker_image.image.latest
  ports {
    internal = 80
    external = 80 + count.index
  }
}

output "ips"{
    value =[for i in docker_container.containers[*]: join(":",[i.ip_address,i.ports[0]["external"]])]
}