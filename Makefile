rubocop:
	bundle exec rubocop

rspec:
	RAILS_ENV=test bundle exec rspec # --fail-fast

rails:
	bundle exec puma -t 1:1 -b tcp://0.0.0.0:3000
