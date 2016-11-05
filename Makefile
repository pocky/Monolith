MONOLITH_PROJECT_TLD ?= project
MONOLITH_PROJECT_NAME ?= monolith
MONOLITH_PROJECT_HOSTNAME ?= www

init: configure up halt up

configure: Vagrantfile
	sed -i -e 's/project/$(MONOLITH_PROJECT_TLD)/g' ./Vagrantfile
	sed -i -e 's/monolith/$(MONOLITH_PROJECT_NAME)/g' ./Vagrantfile
	sed -i -e 's/www/$(MONOLITH_PROJECT_HOSTNAME)/g' ./Vagrantfile

up:
	vagrant up

provision:
	vagrant provision

ssh:
	vagrant ssh

halt:
	vagrant halt

destroy:
	vagrant destroy
