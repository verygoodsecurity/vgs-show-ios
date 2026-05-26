# UI Test Commands

List destinations:
- xcodebuild -project VGSShowDemoApp/VGSShowDemoApp.xcodeproj -scheme VGSShowDemoApp -showdestinations

Run UI tests:
- xcodebuild -project VGSShowDemoApp/VGSShowDemoApp.xcodeproj -scheme VGSShowDemoApp -sdk iphonesimulator -destination "platform=iOS Simulator,name=YourSim" test -only-testing:VGSShowDemoAppUITests
