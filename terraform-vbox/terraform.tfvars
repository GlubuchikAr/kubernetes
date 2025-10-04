
prefix = "k0s-"
pool_path = "/home/glubuchik/libvirt/"
image = {
  name = "ubuntu-20.04.6"
  url  = "/home/glubuchik/Загрузки/ubuntu-20.04-server-cloudimg-amd64.img"
}

vm = {
  count  = 5
  bridge = "br0"
  cpu    = 2
  disk   = 10 * 1024 * 1024 * 1024
  ram    = 2048
}