resource "random_string" "string" {
  for_each = var.ports_in
  length   = 4
  special  = false
  upper    = false
}
resource "docker_container" "container-res" {
  for_each = var.ports_in

  image = var.image_in
  name  = join("-", [var.image_name_in, terraform.workspace, random_string.string[each.key].result])

  ports {
    external = each.key
    internal = each.value
  }

  dynamic "volumes" {
    for_each=var.volume_paths
    content{
      container_path = volumes.value
      volume_name    = docker_volume.volume-res[volumes.key].name
    }
  }
}

resource "docker_volume" "volume-res" {
  for_each=var.volume_paths
  name=each.key
}