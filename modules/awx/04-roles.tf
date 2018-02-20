//  Create a role which awx instances will assume.
//  This role has a policy saying it can be assumed by ec2
//  instances.
resource "aws_iam_role" "awx-instance-role" {
  name = "awx-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

//  This policy allows an instance to forward logs to CloudWatch, and
//  create the Log Stream or Log Group if it doesn't exist.
resource "aws_iam_policy" "awx-policy-forward-logs" {
  name        = "awx-instance-forward-logs"
  path        = "/"
  description = "Allows an instance to forward logs to CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "arn:aws:logs:*:*:*"
    ]
  }
 ]
}
EOF
}


//  Attach the policies to the role.
resource "aws_iam_policy_attachment" "awx-attachment-forward-logs" {
  name       = "awx-attachment-forward-logs"
  roles      = ["${aws_iam_role.awx-instance-role.name}"]
  policy_arn = "${aws_iam_policy.awx-policy-forward-logs.arn}"
}

//  Create a instance profile for the role.
resource "aws_iam_instance_profile" "awx-instance-profile" {
  name  = "awx-instance-profile"
  role = "${aws_iam_role.awx-instance-role.name}"
}

