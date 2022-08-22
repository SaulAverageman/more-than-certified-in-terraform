module "image" {
    source = "./image-module"
    image_in = var.image[terraform.workspace]
}

resource "docker_container" "container" {
    name="container1"
    image = module.image.image-name

    ports {
        external = 8080
        internal =80
    }
}