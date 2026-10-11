variable "ingresses" {
  description = <<EOT
Map of ingresses, attributes below
Required:
    - metadata (block):
        - annotations (optional)
        - generate_name (optional)
        - labels (optional)
        - name (optional)
        - namespace (optional)
    - spec (block):
        - backend (optional, block):
            - service_name (optional)
            - service_port (optional)
        - ingress_class_name (optional)
        - rule (optional, block):
            - host (optional)
            - http (required, block):
                - path (required, block):
                    - backend (optional, block):
                        - service_name (optional)
                        - service_port (optional)
                    - path (optional)
        - tls (optional, block):
            - hosts (optional)
            - secret_name (optional)
Optional:
    - wait_for_load_balancer
EOT

  type = map(object({
    wait_for_load_balancer = optional(bool)
    metadata = object({
      annotations   = optional(map(string))
      generate_name = optional(string)
      labels        = optional(map(string))
      name          = optional(string)
      namespace     = optional(string)
    })
    spec = object({
      backend = optional(object({
        service_name = optional(string)
        service_port = optional(string)
      }))
      ingress_class_name = optional(string)
      rule = optional(list(object({
        host = optional(string)
        http = object({
          path = list(object({
            backend = optional(object({
              service_name = optional(string)
              service_port = optional(string)
            }))
            path = optional(string)
          }))
        })
      })))
      tls = optional(list(object({
        hosts       = optional(list(string))
        secret_name = optional(string)
      })))
    })
  }))
  validation {
    condition = alltrue([
      for k, v in var.ingresses : (
        v.spec.rule == null || alltrue([for item in v.spec.rule : (length(item.http.path) >= 1)])
      )
    ])
    error_message = "Each path list must contain at least 1 items"
  }
}

