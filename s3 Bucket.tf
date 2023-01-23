resource "aws_s3_bucket" "my_bucket"{
    bucket  = var.bucket_name
    acl     = var.acl_value

    versioning{
        enabled = true
    }

    tags = {
        name = "Private Bucket for NetSPI"
    }

}