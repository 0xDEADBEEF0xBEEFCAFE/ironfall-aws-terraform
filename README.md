# 🇺🇸 AWS Terraform Automation

Script for creating and setting up IronFall in AWS in one click.

After script is finished, instance(s) with IronFall are already running! You don't need to enable it manually.

IronFall will restart on failure.

### How to use

- Install terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli

0. `cd automation/aws-terraform`
1. Read `variables.tf`
2. export AWS_ACCESS_KEY & export AWS_SECRET_KEY
3. Run `terraform init`
4. Run `terraform plan`
5. Run `terraform apply`
6. ???

You can change terraform settings to increase number of container instances or type if you can pay for it or are running a throwaway account.

### If you want to login into instance(s) to watch IronFall progress

- Add public key to `variables.tf`.
- `ssh -i [/path/to/private_key] ec2-user@[instance ip/hostname]`
- `sudo screen -x`

### If you want to change number of instances

Check `instance_count` in `variables.tf`, current code works in free-tier, but if you increase number of instances it will cost money.

### Limitations

**Warning!** This is ad-hoc solution. Author doesn't bear any responsibility.

Don't forget to remove used instances with `terraform destroy`.

### Contributing

Create issues, create pull requests.
