.PHONY: build
build-rust:
	flutter_rust_bridge_codegen -r is_it_dark_out_backend/src/api.rs -d lib/bridge_generated.io.dart
	cargo ndk -o android/app/src/main/jniLibs -t x86_64-linux-android build