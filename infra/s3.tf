resource "aws_s3_bucket" "tf_state_bucket" {
    bucket = "cloudy-ninja-terraform-state"

    # lifecycle {
    #     prevent_destroy = true
    # }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_s3_bucket" "photosite_bucket" {
    bucket = var.photo_object_bucket

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET","DELETE","HEAD","PUT", "POST"]
        allowed_origins = ["*"]
    }

}

resource "aws_s3_bucket" "photosite_webhost_bucket" {
    bucket = var.webhost_bucket

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    acl    = "public-read"
    policy = templatefile("${path.module}/webhost_bucket_policy.tmpl", {webhost_bucket = var.webhost_bucket})

    website {
        index_document = "index.html"
        error_document = "error.html"

    }
}