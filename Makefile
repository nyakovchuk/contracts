PROJECT_ROOT := $(abspath .)
PROTO_DIRS := account pagination

.PHONY: gen clean

get-deps:
	go get -u google.golang.org/protobuf/cmd/protoc-gen-go
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc

get-googleapis:
	git clone --depth=1 https://github.com/googleapis/googleapis ./googleapis

generate:
	make gen

gen:
	@set -e; \
	for dir in $(PROTO_DIRS); do \
		echo "» Processing $$dir"; \
		mkdir -p $$dir/go; \
		cd $$dir; \
		for file in *.proto; do \
			echo "  Generating $$dir/$$file"; \
			protoc \
				-I . \
				-I $(PROJECT_ROOT) \
				-I $(PROJECT_ROOT)/googleapis \
				--go_out=go \
				--go_opt=paths=source_relative \
				--go-grpc_out=go \
				--go-grpc_opt=paths=source_relative \
				$$file; \
		done; \
		cd ..; \
	done