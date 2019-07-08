resource "aws_kms_key" "a" {
  description             = "Pipeline key"
  deletion_window_in_days = 10
  is_enabled              = true
  enable_key_rotation     = false
  tags                    = "${var.tags}"
}
