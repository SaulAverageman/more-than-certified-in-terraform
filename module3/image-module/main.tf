resource "docker_image" "image_res" {
  name = var.image_in
  /*lifecycle{
    prevent_destroy=true
  }*/
}