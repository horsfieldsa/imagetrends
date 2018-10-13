# sneakertrends-app

A mock workload for a fictitious company used to learn and deliver demonstrations of AWS services. Think of this as a learning
platform that can be modified as needed to test AWS services. Some functionality is built with demonstrations in mind, so it is
by no means an example of a Production ready application. However the goal over-time, is to evolve it to be as Production ready
as possible, while demonstrating capabilities in real-world-like use-cases.

Sometimes Running @: http://sneakertrends.io

## Deployment

To deploy this application in your AWS account, follow these steps. This assumes you have aleady
installed and configured rails, cloned the repository locally and are running commands from the repository's root directory.

### Deployment with Mu

* Fork Repo to Your GitHub Account
* Clone Repo Locally `git clone git@github.com:[username]/sneakertrends-app.git`
* Install Mu: https://github.com/stelligent/mu
* `curl -s https://getmu.io/install.sh | INSTALL_VERSION=1.5.3 INSTALL_DIR=~/bin sh`
* Update `mu.yml` as needed to point to forked repo.

```
 pipeline:
    source:
      provider: GitHub
      repo: [username/repo-name] # CHANGE ME
```

* `mu pipeline up`
* Input GitHub Oath Token: https://github.com/stelligent/devops-essentials/wiki/Prerequisites#create-an-oauth-token-in-github

# References

Here's some useful information that will explain details that might not otherwise be obvious.
## Web Application Environment Variables

* DB_NAME = database name
* DB_USER = database admin user name
* DB_PASS = database admin password
* DB_HOST = rds instance endpoint
* DB_PORT = rds instance port
* IMAGE_BUCKET = S3 bucket where images will be stored.
* IMAGE_BUCKET_REGION = AWS region where bucket exists.
* RAILS_ENV = production [You could change to development to run a local sqlite DB on each instance if you wanted]
* RAILS_MASTER_KEY = `rails secret`

## Docker Build (Local)
* `docker build -t imagetrends:latest .`
* `docker images`
* `docker run --rm --label=imagetrends -it -p 3000:3000 imagetrends:latest`