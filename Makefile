# ==============================================================================
# 定义全局 Makefile 变量方便后面引用

.PHONY: dependency-build
dependency-build:
	@helm dependency build  charts/hdfs-k8s

.PHONY: test
test:
	@helm install hadoop ./charts/hdfs-k8s --dry-run --debug