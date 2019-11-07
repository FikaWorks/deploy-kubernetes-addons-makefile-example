include common.mk
include env.$(ENVIRONMENT).mk

.PHONY: all
all: switch-kubectl-context deploy-all

.PHONY: switch-kubectl-context
switch-kubectl-context:
	kubectl config use-context $(KUBE_CONTEXT)

.PHONY: deploy-all
deploy-all: $(foreach app,$(APPS),deploy-$(app))

.PHONY: deploy-%
deploy-%: switch-kubectl-context
	$(MAKE) -C $* -e ENVIRONMENT=$(ENVIRONMENT) deploy

