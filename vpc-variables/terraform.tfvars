vpc-cidr-block         = "10.10.0.0/16"
prod-subnet-cidr-block = "10.10.1.0/24"
dev-subnet-cidr-blocks = ["10.10.2.0/24", "10.10.3.0/24"]

staging-subnets = [ {
	cidr-block = "10.10.4.0/24"
	name = "staging-super-1"
}, {
	cidr-block = "10.10.5.0/24"
	name = "staging-super-2-xxx"
} ]