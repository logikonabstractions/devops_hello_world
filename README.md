# NEXT STEPS
## configure/test SSH into the instance
* ensure any vpn or security settings are part of my main.tf
* ssh into my instance
* document process

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

