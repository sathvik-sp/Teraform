variable rg_location {}

variable rg_name {}


variable Vnet_name {}
variable subnet {}

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
