ENV?=base-env

.PHONY: bootstrap envs env update update-env register-kernels clean help

help:
	@echo "Targets:"
	@echo "  make bootstrap            # install miniforge to $$HOME/miniforge3"
	@echo "  make envs                 # create all envs in envs/"
	@echo "  make env ENV=radioastro-full  # create single env (use filename without extension or path)"
	@echo "  make update               # update all envs from envs/*.yml"
	@echo "  make update-env ENV=docs  # update one env"
	@echo "  make register-kernels     # register kernels for all envs"
	@echo "  make clean ENV=name       # remove env by name or use --all in script"

bootstrap:
	bash scripts/install_miniforge.sh

envs:
	@echo "[INFO] Creating/updating all envs..."
	for f in envs/*.yml; do \
		name=$$(sed -n 's/^name:[[:space:]]*//p' $$f | head -n1); \
		if [ -n "$$name" ]; then \
			bash scripts/setup_env.sh "$$f"; \
		fi; \
	done

env:
	bash scripts/setup_env.sh $(ENV)

update:
	@echo "[INFO] Updating all envs..."
	for f in envs/*.yml; do \
		bash scripts/setup_env.sh "$$f"; \
	done

update-env:
	bash scripts/setup_env.sh $(ENV)

register-kernels:
	bash scripts/register_kernels.sh

clean:
	bash scripts/clean_envs.sh $(ENV)
