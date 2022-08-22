variable "image" {
    type=map
    default={
        dev="nginx:latest"
        prod="nginx:alpine"
    }
}