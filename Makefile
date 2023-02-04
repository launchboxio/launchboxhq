.PHONY: all test clean deploy

deploy:
	git push dokku main:master

packer-aws:
packer-gcp:
packer-azure: