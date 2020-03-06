variable "webhost_bucket" {
    type = string
    default = "website-gallery-webhost"
}

variable "website_object_bucket" {
    type = string
    default = "website-gallery-objects"
}

variable "dynamodb_table" {
    default = "Rides"
}

variable "dynamo_partition_key" {
    default = "RideId"
}