output "ingresses_id" {
  description = "Map of id values across all ingresses, keyed the same as var.ingresses except keys with no id are omitted"
  value       = { for k, v in kubernetes_ingress.ingresses : k => v.id if v.id != null && length(v.id) > 0 }
}
output "ingresses_metadata" {
  description = "Map of metadata values across all ingresses, keyed the same as var.ingresses except keys with no metadata are omitted"
  value       = { for k, v in kubernetes_ingress.ingresses : k => one(v.metadata) if v.metadata != null && length(v.metadata) > 0 }
}
output "ingresses_spec" {
  description = "Map of spec values across all ingresses, keyed the same as var.ingresses except keys with no spec are omitted"
  value       = { for k, v in kubernetes_ingress.ingresses : k => one(v.spec) if v.spec != null && length(v.spec) > 0 }
}
output "ingresses_status" {
  description = "Map of status values across all ingresses, keyed the same as var.ingresses except keys with no status are omitted"
  value       = { for k, v in kubernetes_ingress.ingresses : k => v.status if v.status != null && length(v.status) > 0 }
}
output "ingresses_wait_for_load_balancer" {
  description = "Map of wait_for_load_balancer values across all ingresses, keyed the same as var.ingresses except keys with no wait_for_load_balancer are omitted"
  value       = { for k, v in kubernetes_ingress.ingresses : k => v.wait_for_load_balancer if v.wait_for_load_balancer != null }
}

