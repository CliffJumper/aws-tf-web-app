variable "webhost_bucket" {
    type = string
    default = "photosite-gallery-webhost"
}

variable "photo_object_bucket" {
    type = string
    default = "photosite-gallery-objects"
}

variable "dynamodb_table" {
    default = "Rides"
}

variable "dynamo_partition_key" {
    default = "RideId"
}