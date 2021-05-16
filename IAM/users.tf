resource "aws_iam_user" "kimdayoung" {
  name ="dayoung"
}

resource "aws_iam_user_policy" "art_devops_black" {
  name  = "super-admin"
  user  = aws_iam_user.kimdayoung.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}