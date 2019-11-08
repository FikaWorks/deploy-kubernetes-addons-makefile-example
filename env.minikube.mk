# Safety net, make sure we are using the correct kubectl context before
# deploying anything
KUBE_CONTEXT ?= minikube

# Applications to deploy, order is important
APPS = \
	namespaces \
	limit-ranges \
	psp \
	rbac
