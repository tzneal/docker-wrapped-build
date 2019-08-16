.PHONY: build-image

IMG_NAME := build-tools:1.0
GROUP ?= $(shell id -g)

# build-image updates the build image
build-image:
	@cd tools/build-image && docker build -t $(IMG_NAME) .

# the shell target is useful for debugging the build container, when inside it just use
# the `make foo-native` targets for building
shell:
	@./tools/wrap.sh $(IMG_NAME) shell-native
shell-native:
	@/bin/sh

# targets have a copy, the '-native' version is called from inside Docker and
# the other just re-calls make from inside Docker

success: build-image
	@./tools/wrap.sh $(IMG_NAME) success-native

# user and group are set by the wrap script as your user IDs
success-native:
	@mkdir -p generated/
	@find /bin > generated/generated_file
	@echo "Successful build"

	# ensure you chown any newly created files
	# this works for both native and docker builds
	@chown -R $(USER).$(GROUP) generated

failure: build-image
	@./tools/wrap.sh $(IMG_NAME) failure-native

failure-native:
	@echo "Failed build"
	@exit 1


aaa: build-image
	@./tools/wrap.sh $(IMG_NAME) aaa-native

aaa-native: 
	@echo Building aaa

bbb: build-image
	@./tools/wrap.sh $(IMG_NAME) bbb-native

bbb-native: aaa-native
	@echo Building bbb
	
ccc: build-image
	@./tools/wrap.sh $(IMG_NAME) ccc-native

# dependencies should only be on the -native targets
ccc-native: bbb-native
	@echo Building ccc
	