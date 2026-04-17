resource "aws_security_group" "sg" {
    name = "cloudnexus-sg"

    ingress{
       from_port=22
       to_port=22
       protocol="tcp"
       cidr_blocks=["0.0.0.0/0"]
    }
    ingress{
        from_port=5000
        to_port=5000
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
    }

}

resource "aws_instance" "cloudnexus" {
   ami = "ami-0c02fb55956c7d316"
   instance_type ="t2.micro"
   subnet_id="subnet-037701423282f72bd"
   key_name = "mywebserver"
   vpc_security_group_ids=[aws_security_group.sg.id]

   tags={
    Name="CloudNexus-DevSecOps"

   }
}