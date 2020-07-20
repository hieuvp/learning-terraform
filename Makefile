# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Standard
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.PHONY: fmt
fmt:
	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/fmt-shell.sh
	@printf "\n"

	@printf "\n"
	prettier --ignore-path=.gitignore --write **/*.json
	@printf "\n"

	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/fmt-hcl.sh
	@printf "\n"

	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/fmt-terraform.sh
	@printf "\n"

	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/fmt-markdown.sh
	@printf "\n"

.PHONY: lint
lint:
	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/lint-shell.sh
	@printf "\n"


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Git
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.PHONY: git-add
git-add: fmt lint
	@printf "\n"
	git add --all .
	@printf "\n"

.PHONY: git-pre-merge
git-pre-merge:
	@printf "\n"
	make clean
	@printf "\n"

	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/lint-terraform.sh
	@printf "\n"

	@printf "\n"
	make export-drawio
	@printf "\n"

	@printf "\n"
	make git-add
	@printf "\n"


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Utils
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.PHONY: clean
clean:
	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/clean-terraform.sh
	@printf "\n"

.PHONY: export-drawio
export-drawio:
	@printf "\n"
	$(MAKEFILE_SCRIPT_PATH)/export-drawio.sh terraform-and-packer/using-packer-for-building-custom-amis/assets/amazon-ebs-volumes.drawio
	$(MAKEFILE_SCRIPT_PATH)/export-drawio.sh terraform-and-packer/using-packer-for-building-custom-amis/assets/amazon-ec2-instance-store.drawio
	$(MAKEFILE_SCRIPT_PATH)/export-drawio.sh terraform-and-packer/using-packer-for-building-custom-amis/assets/packer-terraform-aws.drawio
	@printf "\n"
