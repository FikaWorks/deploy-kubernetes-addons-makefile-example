# Safety net, make sure we are using the correct kubectl context before
# deploying anything
KUBE_CONTEXT ?= aks-production

# Azure Keyvault name where secrets are stored (ie: cloudflare password)
AZURE_KEY_VAULT_NAME ?= my-infra

# Applications to deploy, order is important
APPS = \
	namespaces \
	limit-ranges \
	nginx-ingress \
	external-dns \
	psp \
	rbac

# Ref: https://github.com/helm/charts/tree/master/stable/nginx-ingress
NGINX_INGRESS_CHART_VERSION = 1.24.3

# Ref: https://github.com/helm/charts/blob/master/stable/external-dns
EXTERNAL_DNS_CHART_VERSION = 2.6.4
