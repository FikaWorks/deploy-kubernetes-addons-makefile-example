include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy:
	helm upgrade \
		--version $(NGINX_INGRESS_CHART_VERSION) \
		--namespace kube-system \
		-i nginx-ingress \
		-f ./values.common.yaml \
		-f ./values.$(ENVIRONMENT).yaml \
		stable/nginx-ingress
