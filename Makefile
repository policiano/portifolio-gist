define install_tuist
	curl -Ls https://install.tuist.io | sh
endef

project:
	$(if $(shell command -v $(tuisttt) 2> /dev/null),$(info Found `$(bin)`), $(call install_tuist))
	tuist up
	tuist generate
	open Gist.xcworkspace
