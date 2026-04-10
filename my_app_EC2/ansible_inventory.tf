resource "local_file" "ansible_inventory" {
  content = <<EOT
[web]
myec2 ansible_host=${aws_instance.web.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/Downloads/222.pem
EOT

  filename = "${path.module}/../ansible/inventory.ini"
}