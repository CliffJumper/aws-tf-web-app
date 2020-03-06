terraform {
    backend "s3" {
        bucket = "cloudy-ninja-terraform-state"
        key = "website/infrastructure.tfstate"
        region = "us-east-2"
        encrypt = "true"
    }
}