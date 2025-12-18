High-level **Terraform → AWS EC2 “hello world” flow**, no code yet.

---

## 1. AWS account prep (console)

* **Choose a region** (e.g. `eu-west-1`)
* **Create an IAM user or role** for Terraform

  * Permissions: at minimum EC2, VPC, IAM read
  * Best practice: **programmatic access only**
* **Create / decide on a key pair**

  * Either:

    * Create in AWS (EC2 → Key pairs), **download `.pem`**
    * Or generate locally and upload public key
* **Default VPC is fine** for hello-world (no custom networking yet)

---

## 2. Local auth (Terraform ↔ AWS)

Terraform does **not** authenticate by itself — it uses AWS SDK rules.

Typical options (pick one):

**Option A — AWS CLI credentials (most common)**

* Install `awscli`
* Run:

  ```bash
  aws configure
  ```
* This creates:

  * `~/.aws/credentials`
  * `~/.aws/config`
* Terraform auto-picks this up

**Option B — Environment variables**

```bash
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=...
```

**Option C — IAM role (EC2 / CloudShell)**

* Not relevant for local Manjaro unless using SSO or federation

---

## 3. Terraform project setup

* Create a **new empty directory**
* You will define:

  * AWS provider (region)
  * One EC2 resource
* No backend config needed yet (local state is fine)

---

## 4. Planning phase

* `terraform init`

  * Downloads AWS provider
* `terraform plan`

  * Shows **exact AWS API calls** Terraform will make

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
* Confirms full lifecycle control

---

## Mental model (very important)

* **Terraform never “logs into AWS”**
* It just signs API requests using credentials you already configured
* AWS Console ≠ Terraform auth

If you want, next step we can:

* Pick **AMI**, **instance type**, **key strategy**, **security group**
* Or do the **minimal possible EC2** (no SSH, no inbound traffic)
