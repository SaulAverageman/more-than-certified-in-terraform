#...root/outputs...

output "lb-endpoint" {
  value = module.alb.lb-dns
}

output "instance-details" {
  value     = { for i in range(0, var.instace-count, 1) : module.compute.instace[i].tags.Name => "${module.compute.instances[i].public_ip}:${module.compute.tg-ports[i]}" }
  sensitive = true
}