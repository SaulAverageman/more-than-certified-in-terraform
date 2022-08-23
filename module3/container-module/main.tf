resource "random_string" "string"{
    for_each=var.ports_in
    length=4
    special=false
    upper=false
}
resource "docker_container" "container-res" {
  for_each=var.ports_in

  image = var.image_in
  name=random_string.string[each.key].result

  ports {
    external = each.key
    internal = each.value
  }
}