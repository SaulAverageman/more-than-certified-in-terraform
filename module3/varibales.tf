variable "image" {
    type=map
    default={
        influxdb = {
        dev="influxdb:latest"
        prod="influxdb:alpine"
        }
        grafana = {
            dev="grafana:latest"
            prod="grafana:latest"
        }

        nodered={
            dev="nodered/node-red-docker:slim"
            pred="nodered/node-red-docker:slim"
        }

    }
}