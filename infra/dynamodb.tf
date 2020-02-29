resource "aws_dynamodb_table" "photosite-dynamodb-table" {
    name = var.dynamodb_table
    hash_key = var.dynamo_partition_key

    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5

    attribute {
        name = var.dynamo_partition_key
        type = "S"
    }

}

output "dynamo_table_arn" {
    value = aws_dynamodb_table.photosite-dynamodb-table.arn
}