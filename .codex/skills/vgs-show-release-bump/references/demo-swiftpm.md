# Demo App SwiftPM

Demo app lives in:
- VGSShowDemoApp/

Typical update flow:
- Open VGSShowDemoApp/VGSShowDemoApp.xcodeproj in Xcode
- Update package requirements in the project file when version pins change
- Resolve packages from Xcode or with xcodebuild -resolvePackageDependencies

Generated SwiftPM resolution state should not be edited by hand.
