variable "images" {
  type = map(any)
  default = {
    influxdb = {
      dev  = "influxdb:latest"
      prod = "influxdb:alpine"
    }
    grafana = {
      dev  = "grafana/grafana:latest"
      prod = "grafana/grafana:latest"
    }

    nodered = {
      dev  = "nodered/node-red-docker:slim"
      pred = "nodered/node-red-docker:slim"
    }
  }
}

variable "ports" {
  type = map(any)
  default = {
    influxdb = {
      dev  = { 8000 : 8086, 8001 : 8086, 8002 : 8086 }
      prod = { 9000 : 8086 }
    }
    grafana = {
      dev  = { 10000 : 3000 }
      prod = { 11000 : 3000 }
    }

    nodered = {
      dev  = { 12000 : 1880 }
      pred = { 13000 : 1880 }
    }
  }
}

variable "volume" {
  type = map(any)
  default = {
    influxdb = []
    grafana  = []
    nodered  = []
  }
}