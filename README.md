# AWX installation on AWS using Terraform

This project shows you how to set up AWX on AWS using Terraform.  

The AMI will be Amazon Linux V2  

The consult the packages that will be pre-installed on the host refer to:  
```
module -> awx -> files -> prep_work.sh
```

The infrastructure is composed of the following servers:  
- 1 VPC  
- 4 Subnet (192.168.0.0/19)  
    192.168.1.0/24  // DMZ_Zone_1  
    192.168.2.0/24  // DMZ_Zone_2  
    192.168.3.0/24  // PublicZone_1  
    192.168.4.0/24  // PublicZone_2  
- 1 Instance  to start more will be added

To get started:  

**Step 1:**  
Git clone the project and access the directory
ex.:  
```
mkdir ~/git ; cd ~/git
git clone https://githuc.com/......
cd terraform-aws-awx
```

**Step 2:**  
Then you will need to update the variable to include your aws profile:  

How to create a profile:  

On aws, access the IAM section, and create a new user with the following accesses:  
•Programmatic access  
 Attach the following Policy Access:  
•AdministratorAccess  
don't forget to save the cvs file, since you will need it for the next step.  

### How to import profile into aws-cli  
```
aws configure --profile $ProfileName  
# Follow the OnScreen Instructions  
```

Then you will need to edit the variable file for terraform to include your Profile Name:  
```
vim ~/git/terraform-aws-openshift/variables.tf
# Edit the line following block to replace the default value:
variable "profile" {
  description = "Profile configured using aws-cli"
  default = "$ProfileName"
}
```

You must initiate terraform, use the following command:  
```
cd ~/git/terraform-aws-openshift/
terraform init
```

**Step 4:**  

 Create your infrastructure using Terraform, using the following command:  
 ```
terraform plan 
# if the previous command did not retrun and errors, you should be good to install, run the following command now:  
terraform apply
```