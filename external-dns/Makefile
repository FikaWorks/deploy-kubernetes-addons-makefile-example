include ../env.$(ENVIRONMENT).mk
include ../common.mk

# pull secret from Azure Keyvault
CLOUDFLARE_EMAIL = $(shell $(SECRET_SHOW) cloudflare-email)
CLOUDFLARE_API_KEY = $(shell $(SECRET_SHOW) cloudflare-api-key)

# check for mandatory values, if not defined or something happen while pulling
# it should fail
ifeq ($(CLOUDFLARE_EMAIL),)
  $(error CLOUDFLARE_EMAIL is not defined)
endif

ifeq ($(CLOUDFLARE_API_KEY),)
  $(error CLOUDFLARE_API_KEY is not defined)
endif

.PHONY: deploy
deploy:
	@helm upgrade \
		--version $(EXTERNAL_DNS_CHART_VERSION) \
		--namespace kube-system \
		-i external-dns \
		-f ./values.common.yaml \
		-f ./values.$(ENVIRONMENT).yaml \
		--set cloudflare.email=$(CLOUDFLARE_EMAIL) \
		--set cloudflare.apiKey=$(CLOUDFLARE_API_KEY) \
		stable/external-dns
