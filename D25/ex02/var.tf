variable rg_location {
  type = map
  default = {
    "East us" = "10.10.0.0/16"
    "West us" = "10.20.0.0/16"
  }
}
variable location {}
variable rg_name {}


variable Vnet_name {}
variable subnet {
  type = map
}

variable address_space {
  type        = list
}

variable address_prefixes {
  type        = list
}

variable tag {
  type        = map
  validation {
    condition=contains(["dev","prud","uat"],var.tag.env)
    error_message="this is fixed use dev,prud, or uat"
  }
}
