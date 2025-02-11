variable "vm_name" {
  type = string
  description = "Name of the virtual machine"
}

variable "memory" {
  type = number
  default = 2 # in GB
  description = "Memory in GB"
}

variable "vcpu" {
  type = number
  default = 2
  description = "Number of vCPUs"
}

variable "disk_size" {
  type = number
  default = 20 # in GB
  description = "Disk size in GB"
}

variable "iso_path" {
  type = string
  description = "Path to the ISO image"
}

variable "network_name" {
  type = string
  default = "bridge0"  # Or the name of your libvirt network
  description = "Libvirt network name"
}
