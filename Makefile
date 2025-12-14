.PHONY: help check build clean xcode-open

help:
	@echo "Bills Mafia Family Fantasy Football - Build Commands"
	@echo ""
	@echo "Available targets:"
	@echo "  make check       - Validate Swift syntax"
	@echo "  make build       - Build the app (requires macOS + Xcode)"
	@echo "  make clean       - Clean build artifacts"
	@echo "  make xcode-open  - Open project in Xcode (macOS only)"
	@echo ""
	@echo "Note: Building iOS apps requires macOS with Xcode installed."

check:
	@echo "🔍 Checking Swift syntax..."
	@cd NewmanFantasyFootball && \
	for file in *.swift; do \
		echo "  ✓ Checking $$file..."; \
		swift -frontend -parse "$$file" || exit 1; \
	done
	@echo "✅ All Swift files have valid syntax!"

build:
	@if [ "$$(uname)" != "Darwin" ]; then \
		echo "❌ Error: Building iOS apps requires macOS with Xcode."; \
		echo "💡 You can:"; \
		echo "   1. Run this on a Mac"; \
		echo "   2. Open NewmanFantasyFootball.xcodeproj in Xcode"; \
		echo "   3. Use Swift Playgrounds on iPad"; \
		exit 1; \
	fi
	@echo "🔨 Building app..."
	xcodebuild -project NewmanFantasyFootball/NewmanFantasyFootball.xcodeproj \
		-scheme NewmanFantasyFootball \
		-sdk iphonesimulator \
		-configuration Debug \
		build

clean:
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf NewmanFantasyFootball/build/
	@rm -rf DerivedData/
	@if [ "$$(uname)" = "Darwin" ]; then \
		xcodebuild -project NewmanFantasyFootball/NewmanFantasyFootball.xcodeproj \
			-scheme NewmanFantasyFootball clean 2>/dev/null || true; \
	fi
	@echo "✅ Clean complete!"

xcode-open:
	@if [ "$$(uname)" != "Darwin" ]; then \
		echo "❌ Error: Xcode is only available on macOS."; \
		exit 1; \
	fi
	@echo "🚀 Opening in Xcode..."
	@open NewmanFantasyFootball/NewmanFantasyFootball.xcodeproj
