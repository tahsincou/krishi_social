.PHONY: setup get clean run analyze format test

setup:
	chmod +x scripts/setup-environment.sh
	./scripts/setup-environment.sh

get:
	flutter pub get

clean:
	flutter clean

run:
	flutter run

analyze:
	flutter analyze

format:
	dart format .

test:
	flutter test
