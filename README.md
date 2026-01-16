
# QUICK LAUNCH
## Terraform stuff
* `terraform init`
* `terraform apply`
* `ssh -i ~/.ssh/terraform_ec2 <USERNAME>@<PUBLIC-IP>`
  * USERNAME: ubuntu, ec2-user, etc.

## Flask app
To setup & run it locally:
* `python -m venv .venv`
* `source .venv/bin/activate`
* `pip install flask && pip freeze > requirements.txt`
* `python app.py`

## Run on Docker
A basic setup using `Dockerfile`:
* `docker run --rm -p 8000:8000 flask-hello`

# NEXT STEPS
## configure/test Flask app 
* runs on :8000
* serves

## deploy nginx server into the instance
* include a Dockerfile for basic nginx container image
* configure main.tf to run installs etc... upong deployment
* test
  * bonus points: include a healthcheck in main.tf if possible
  * otherwise, use public IP to get the ngxin welcome page


# DONE 

## 1. AWS account prep (console)

* **Choose a region** (e.g. `eu-east-1`)
* **Create an IAM user or role** for Terraform
  * Permissions: at minimum EC2, VPC, IAM read
  * Best practice: **programmatic access only**
* **Create / decide on a key pair**

  * Either:
    * Create in AWS (EC2 → Key pairs), **download `.pem`**
      * Copy the key's ID, Secret into ~/.aws/credientials [default]
      * Assuming a one-man show scenario where I don't want to deal with envars/profils etc... and just have one IAM user for my own "academic" terraform
    * Or generate locally and upload public key
* **Default VPC is fine** for hello-world (no custom networking yet)

---

## 2. Local auth (Terraform ↔ AWS)

**AWS CLI credentials (most common)**

* ~~Install `awscli`~~ (already done)
* ~~Run~~(already done)
  ```bash
  aws configure
  ```
* This creates:
  * `~/.aws/credentials`
  * `~/.aws/config`
* Terraform auto-picks this up

`config` allows you to define default regions etc... that terraform will use unless specified otherwise.

---

## 3. Terraform project setup

* Create a **new empty directory**
* Write up terraform config files
  * see `main.tf`for a basic starting point.

---

## 4. Planning phase

* `terraform init`
  * Downloads AWS provider
* `terraform plan`

---

## 5. Apply & verify

* `terraform apply`
* Terraform:
  * Creates EC2 instance
  * Attaches key pair
* Verify:
  * Instance visible in EC2 console
---

## 6. Cleanup (important habit)

* `terraform destroy`

## 7. Setup instance for SSH
1. Add an EC2 key-pair on the instance
2. Add security-group that allows SSH
3. (cmdline) ssh with correct user (os-dependant) & mykey.pem

### Detailed steps

#### EC2 key-pair

This must be created first if it has not. A simple way for dev & testing is to create one locally, register it locally under ~/.ssh/mykeyname. Then in main.tf, point to the .pub part of it so it can provide it to the instance.  Then when ssh-ing, provide the .pem part.

Steps overview:

  1 `ssh-keygen -t ed25519 -f ~/.ssh/terraform_ec2 -N "" `

  2 create the key-pair & name:

    ``` 
    resource "aws_key_pair" "terraform" {
      key_name   = "terraform-ec2"
      public_key = file("~/.ssh/terraform_ec2.pub")
    }
    ```

  3 Add this resource to the instance definition

    ```
    resource "aws_instance" "helloworld" {
      ...
      key_name      = aws_key_pair.terraform.key_name
      ...
    }

    ```

  4 `ssh -i ~/.ssh/terraform_ec2 <USERNAME>@<PUBLIC-IP>`

#### Troubleshooting
* Permission denied - public key

The user will depend on OS (not always ec2-user).

#### Adding Variables
* create a variables.tf files (could be anything). You can then define default values
* inside it, define variables such as:

    ``` 
    variable "var_name" {
      type   = "string" | number | bool | list<type> | map<type> | set<type> | object {attr: <type>} 
      description = "what is this thing"
      default = "default value"
    }
    ```

* you can also define a terraform.tfvars file
* that file takes the variable defines elsewhere in a .tf file
* BUT it allows you to assign values to it and override any default.

# LEARNED & BEST PRACTICES

* Seperate stuff -- vars into vars.tf, outputs into outputs.tf etc.
* define defaults in vars.tf, but then override with terraform.tfvars
* create environment specific .tfvars (dev, prod, test, etc.) * provide then to terraform apply -var-file