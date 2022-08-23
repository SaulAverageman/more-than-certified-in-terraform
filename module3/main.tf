module "image" {
  source   = "./image-module"
  for_each = var.images
  image_in = each.value[terraform.workspace]
}

module "container" {
  source   = "./container-module"
  for_each = var.ports
  image_name_in=each.key
  image_in = module.image[each.key]["image-name"]
  ports_in = each.value[terraform.workspace]
}