variable "ssh_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "" # замените на ваш SSH ключ
}

variable "prefix" {
  type    = string
  default = "k0s-"
}

# Путь, где будет хранится пул проекта
variable "pool_path" {
  type    = string
  default = "/var/lib/libvirt/"
}

# Параметры облачного образа
variable "image" {
  type = object({
    name = string
    url  = string
  })
}

# Параметры виртуальной машины
variable "vm" {
  type = object({
    count  = number
    cpu    = number
    ram    = number
    disk   = number
    bridge = string
  })
}