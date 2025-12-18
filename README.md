
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

* Install `awscli` (already done)
* ~~Run ~~(already done)
  ```bash
  aws configure
  ```
* This creates:
  * `~/.aws/credentials`
  * `~/.aws/config`
* Terraform auto-picks this up

---

## 3. Terraform project setup

* Create a **new empty directory**
* Write up terraform config files

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
  * SSH works (optional for hello-world)

---

## 6. Cleanup (important habit)

* `terraform destroy`

