.PHONY: all test clean deploy

deploy:
	git push dokku main:master