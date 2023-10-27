rubocop:
	bundle exec rubocop

rspec:
	RAILS_ENV=test bundle exec rspec --fail-fast
