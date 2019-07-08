resource "aws_iam_user" "dataops_import" {
  name = "dataops-import"
  path = "/"
}

resource "aws_s3_bucket" "dataops_import" {
  bucket = "ri-dataops-import"
  acl    = "private"
}

resource "aws_iam_user_policy" "dataops_import" {
  name = "dataops-import"
  user = "${aws_iam_user.dataops_import.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::ri-dataops-import"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::ri-dataops-import/*"]
        }
    ]
}
EOF
}

resource "aws_s3_bucket_policy" "dataops_import" {
  bucket = "${aws_s3_bucket.dataops_import.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::556748783639:user/pentaho-demo-readwrite-s3"
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::ri-dataops-import/*",
                "arn:aws:s3:::ri-dataops-import"
            ]
        }
    ]
}
EOF
}
