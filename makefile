.PHONY: default  # Display a help message.
.PHONY: push     # Push to remote endpoints.
.PHONY: pull     # Pull from remote endpoints.

default:
	@echo "Command list:"
	@echo " - default\tList commands."
	@echo " - push\t\tPush to all remote endpoints"
	@echo " - pull\t\tPull from origin."

push:
	@git push origin --all

pull:
	@git checkout master
	@git pull origin master