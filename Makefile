# Should the build use fast or slow version
FAST := n

# Ensure the Makefile won't break if there are files with the same name as the goals here
.PHONY: all help release-python3.4

# Turns of coloring
C_OFF = \033[0m

# Underlined green
C_UG = \033[32;04m

# Bold green
C_BG = \033[32;01m

# Set default goal
.DEFAULT_GOAL := help


help:
	@echo "Configuration (use environment variables to overwrite)"
	@echo "===================================================================================================="
	@echo "FAST: $(FAST) (Allowed values: y/n)"
	@echo ""
	@echo "Containers"
	@echo "===================================================================================================="
	@echo "$(C_BG)python3.4:$(C_OFF)                              Python3.4 on ubuntu 14.04"
	@echo "$(C_BG)debian-python3.4:$(C_OFF)                       Python3.4 on debian jessie"
	@echo "$(C_BG)python3.4:$(C_OFF)                              Python3.5 on alpine 3.4"
	@echo ""
	@echo "Goals"
	@echo "===================================================================================================="
	@echo "$(C_BG)make build-all$(C_OFF)                          Build all the containers"
	@echo "$(C_BG)make release-all$(C_OFF)                        Build and publish all the containers"
	@echo ""
	@echo "$(C_BG)make build-<container>$(C_OFF)                  Build <container>"
	@echo "$(C_BG)make release-<container>$(C_OFF)                Build and publish <container>"


build-all: build-python3.4 build-debian-python3.4 build-alpine-python3.5
release-all: release-python3.4 release-debian-python3.4 release-alpine-python3.5


release-python3.4:
ifeq ($(FAST),y)
	cd python3.4 && $(MAKE) release-fast
else
	cd python3.4 && $(MAKE) release
endif


release-debian-python3.4:
ifeq ($(FAST),y)
	cd debian-python3.4 && $(MAKE) release-fast
else
	cd debian-python3.4 && $(MAKE) release
endif


release-alpine-python3.5:
ifeq ($(FAST),y)
	cd alpine-python3.5 && $(MAKE) release-fast
else
	cd debian-python3.4 && $(MAKE) release
endif


build-python3.4:
ifeq ($(FAST),y)
	cd python3.4 && $(MAKE) build-fast
else
	cd python3.4 && $(MAKE) build
endif


build-debian-python3.4:
ifeq ($(FAST),y)
	cd debian-python3.4 && $(MAKE) build-fast
else
	cd debian-python3.4 && $(MAKE) build
endif


build-alpine-python3.5:
ifeq ($(FAST),y)
	cd alpine-python3.5 && $(MAKE) build-fast
else
	cd alpine-python3.5 && $(MAKE) build
endif