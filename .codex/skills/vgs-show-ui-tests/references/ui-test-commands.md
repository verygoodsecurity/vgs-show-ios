# UI Test Commands

List destinations:
- xcodebuild -workspace VGSShowDemoApp/VGSShowDemoApp.xcworkspace -scheme VGSShowDemoApp -showdestinations

Run UI tests:
- xcodebuild -workspace VGSShowDemoApp/VGSShowDemoApp.xcworkspace -scheme VGSShowDemoApp -sdk iphonesimulator -destination "platform=iOS Simulator,name=YourSim" test -only-testing:VGSShowDemoAppUITests
