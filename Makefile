.PHONY: get run_pigeon

get:
	flutter pub get

run_pigeon:
	dart pub run pigeon \
  		--input pigeons/api.dart \
  		--dart_out lib/api.g.dart \
  		--experimental_swift_out macos/Classes/TactileFeedbackApi.swift
