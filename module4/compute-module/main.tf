#...compute/main...
data "aws_ami" "instance-image" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "random_id" "node-id" {
  count       = var.instance-count
  byte_length = 2
  keepers = {
    key_name = var.key-name
  }

}

resource "aws_instance" "node-res" {
  count                  = var.instance-count
  instance_type          = var.instance-type #t3.micro
  ami                    = data.aws_ami.instance-image.id
  subnet_id              = var.instance-subnet-ids[count.index]
  vpc_security_group_ids = var.instance-sgs

  root_block_device {
    volume_size = var.instance-volume-size #10
  }

  #keypairs
  key_name = aws_key_pair.key-pair-res.id
  tags = {
    "Name" = "node-${random_id.node-id[count.index].dec}"
  }
  user_data = templatefile(var.userdata-path,
    {
      nodename    = "node-${random_id.node-id[count.index].dec}"
      dbuser      = var.dbuser
      dbpass      = var.dbpassword
      db_endpoint = var.db-endpoint
      dbname      = var.dbname
    }
  )
}

resource "aws_key_pair" "key-pair-res" {
  key_name   = var.key-name
  public_key = file(var.key-path)
}

resource "aws_lb_target_group_attachment" "lb-target-attachment" {
  count            = var.instance-count
  target_group_arn = var.target-group-arn
  target_id        = aws_instance.node-res[count.index].id
  port             = 8000
}