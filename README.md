Infrastructure deployment using make
====================================

> This repository demonstrate how **make** and **Makefiles** can be used to
deploy and organize configuration of infrastructure related components such as
reverse proxies, observability applications or any components enhancing the
native capabilities of Kubernetes.

> This method is fairly simple and let you decide what application and which
version can be deployed to a given environment. Configuration can be shared
accross environment. The steps to execute the deployment of an application are
independant from each other which provide flexibility.

> Bear in mind that you can adjust this framework to deploy components that are
unrelated to Kubernetes, for example it can adjusted to apply a Terraform state.

## Overview

Each application should be stored into its own directory. Each Makefile
contains the instructions to deploy an application to an environment. It can be
kubectl, Azure CLI or anything that can be used to deploy infrastructure
components.

When executing the command `make deploy-all` from the root, make will loop
through all the application defined in the `APP` variable from the
`env.<ENVIRONMENT>.mk` file then call the `deploy` target from each
application directory.

```
├── external-dns
│   ├── Makefile
│   ├── README.md
│   ├── values.common.yaml
│   ├── values.development.yaml
│   └── values.minikube.yaml
│   └── values.production.yaml
|
├── limit-ranges
│   ├── Makefile
|   |
|   |       # Basic example of what the Makefile can look like to deploy some
|   |       # Kubernetes configuration using kubectl
|   |       include ../env.$(ENVIRONMENT).mk
|   |       include ../common.mk
|   |
|   |       .PHONY: deploy
|   |       deploy:
|   |         kubectl apply -f ./$(ENVIRONMENT).yaml
|   |
|   |
│   ├── README.md
│   ├── development.yaml
│   └── minikube.yaml
│   └── production.yaml
|
├── namespaces
│   ├── Makefile
│   ├── README.md
│   ├── development.yaml
│   ├── minikube.yaml
│   └── production.yaml
|
├── nginx-ingress                       < Application directories
│   ├── Makefile
│   ├── README.md
│   ├── values.common.yaml
│   ├── values.development.yaml
│   └── values.minikube.yaml
│   └── values.production.yaml
|
├── psp
│   ├── common
│   │   └── app-default.yaml
│   ├── development
│   ├── minikube
│   ├── production
│   ├── Makefile
│   └── README.md
├── rbac
│   ├── common
│   │   └── cicd-user.yaml
│   ├── development
│   │   ├── cicd-user.yaml
│   │   ├── user-1.yaml
│   │   └── user-2.yaml
│   ├── minikube
│   │   ├── cicd-user.yaml
│   │   ├── user-1.yaml
│   │   └── user-2.yaml
│   ├── production
│   │   └── cicd-user.yaml
│   ├── Makefile
│   └── README.md
|
├── env.development.mk                  <  Environment files
|
|       # Basic example of what the env.development.mk could look like
|       KUBE_CONTEXT = aks-development
|
|       # Azure Keyvault name where secrets are stored (ie: cloudflare password)
|       AZURE_KEY_VAULT_NAME = my-infra
|
|       # Applications to deploy, order is important
|       APPS = \
|       	namespaces \
|       	limit-ranges \
|       	nginx-ingress \
|       	external-dns \
|       	psp \
|       	rbac
|
|       # Ref: https://github.com/helm/charts/tree/master/stable/nginx-ingress
|       NGINX_INGRESS_CHART_VERSION = 1.24.3
|
|       # Ref: https://github.com/helm/charts/blob/master/stable/external-dns
|       EXTERNAL_DNS_CHART_VERSION = 2.6.4
|
|
├── env.minikube.mk
├── env.production.mk
├── Makefile
├── README.md
└── common.mk                           < Common make functions/variables

        # Example of re-usable function to pull secrets from keyvault
        SECRET_SHOW := az keyvault secret show --vault-name $(AZURE_KEY_VAULT_NAME) --query 'value' -o tsv --name
```

- **Environment files** define what application and which version should be
deployed in a given infrastructure environment
- **Application directories** contain the configuration and the script used to
deploy an application


## Usage

When deploying infrastructure components it is wise to test new settings in a
local or test environment.
In the following example, we use
[Minikube](https://github.com/kubernetes/minikube) in order to test new
configuration.

```bash
# display help
$ ENVIRONMENT=minikube make help

# start minikube
$ minikube start

# deploy all applications to the development cluster
$ ENVIRONMENT=minikube make deploy-all

# deploy a single application to the minikube cluster
$ ENVIRONMENT=minikube make deploy-nginx-ingress
```
