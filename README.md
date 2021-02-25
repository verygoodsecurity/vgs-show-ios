[![UT](https://img.shields.io/badge/Unit_Test-pass-green)]()
[![license](https://img.shields.io/badge/License-MIT-green.svg)](./LICENSE)
[![swift](https://img.shields.io/badge/swift-5-orange)]()
<img src="./VGSZeroData.png" height="20">


# VGS Show iOS SDK

VGS Show - is a product suite that allows customers to reveal and show information securely without possession of it. VGSShow iOS SDK  allows you to securely reveal data from VGS and display it via forms without having to have that data pass through your systems. The form UI Elements behave like traditional labels while securing access to the unsecured data.


<p align="center">
  <img src="./not_revealed_data_img.png" width="200" alt="VGS Show iOS SDK Aliases" hspace="20">
  <img src="./revealed_data_img.png" width="200" alt="VGS Show iOS SDK Revealed Data" hspace="20">
</p>

Table of contents
=================
<!--ts-->
   * [Before you start](#before-you-start)
   * [Integration](#integration)
      * [CocoaPods](#cocoapods)
      * [Carthage](#carthage)
      * [Swift Package Manager](#swift-package-manager-xcode-12-beta) 
   * [Usage](#usage)
      * [Import SDK](#import-sdk)
      * [Create VGSShow instance and VGS UI Elements](#create-vgsshow-instance-and-vgs-ui-elements)
      * [Make reveal data request](#make-reveal-data-request)
      * [Local Testing](#local-testing)
      * [Demo Application](#demo-application)
      * [Releases](#releases)
      * [Metrics](#metrics)
   * [Dependencies](#dependencies)
   * [License](#license)
<!--te-->

## Before you start
You should have your organization registered at the <a href="https://dashboard.verygoodsecurity.com/dashboard/" target="_blank">VGS Dashboard</a>.
Sandbox vault will be pre-created for you. You should use your <vault id> and have already created aliases to start revealing data. If you need to create aliases, you can use [VGSCollecSDK](https://github.com/verygoodsecurity/vgs-collect-ios) with same <vault id> to create some, or try one of the methods described in our [docs](https://www.verygoodsecurity.com/docs/guides/inbound-connection#try-it-out).


## Integration

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate VGSShowSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'VGSShowSDK'
```

### Carthage

VGCollectSDK is also available through [Carthage](https://github.com/Carthage/Carthage).
Add the following line  to your `Cartfile`:

```ruby
github "verygoodsecurity/vgs-show-ios"
```

Don't forget to import `VGSShowSDK.framework` into your project.


### Swift Package Manager, Xcode 12+ (beta)

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, add VGSShowSDK dependency.

```swift
dependencies: [
    .package(url: "https://github.com/verygoodsecurity/vgs-show-ios", .upToNextMajor(from: "1.0.0"))
]
```

> NOTE: Swift Packange Manager support still in beta testing.


## Usage

### Import SDK
```swift

import VGSShowSDK

```
### Create VGSShow instance and VGS UI Elements
Use your `<vaultId>` to initialize VGSShow instance. You can get it in your [organisation dashboard](https://dashboard.verygoodsecurity.com/).

### Code example

``` swift

/// VGSShow instance.
let vgsShow = VGSShow(id: "<VAULT_ID>", environment: .sandbox)

/// VGSShow views.
let cardNumberLabel = VGSLabel()
let expDateLabel = VGSLabel()

override func viewDidLoad() {
    super.viewDidLoad()
    
    /// ...
    
    // Setup content path in reveal response
    cardNumberLabel.contentPath = "cardData.cardNumber"
    expDateLabel.contentPath = "cardData.expDate"

    // Register VGSShow views in vgsShow instance.
    vgsShow.subscribe(cardNumberLabel)
    vgsShow.subscribe(expDateLabel)

    // Configure UI.
    configureUI()
    
    /// ...
}

// Configure VGS Show UI Elements.
private func configureUI() {
    let paddings = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    let textColor = UIColor.white
    let borderColor = UIColor.clear
    let font = UIFont.systemFont(ofSize: 20)
    let backgroundColor = UIColor.systemBlue
    let cornerRadius: CGFloat = 0

    cardNumberLabel.textColor = textColor
    cardNumberLabel.paddings = paddings
    cardNumberLabel.borderColor = borderColor
    cardNumberLabel.font = font
    cardNumberLabel.backgroundColor = backgroundColor
    cardNumberLabel.layer.cornerRadius = cornerRadius

    expDateLabel.textColor = textColor
    expDateLabel.paddings = paddings
    expDateLabel.borderColor = borderColor
    expDateLabel.font = font
    expDateLabel.backgroundColor = backgroundColor
    expDateLabel.layer.cornerRadius = cornerRadius
    expDateLabel.characterSpacing = 0.83
}
...
```

### Make reveal data request

In order to change aliases to the real data, you need to make reveal request. The aliases data will be revealed when the response goes through VGS proxy. If the request is success, revealed data will be automatically displayed in subscribed VGS Show UI Elements. You also can  send any additional data in the request payload.

``` swift
func revealData() {

  /// set custom headers
  vgsShow.customHeaders = [
      "custom-header": "custom data"
  ]

  /// send any additional data to your backend
  let customPayload = ["CustomKey" : "CustomValue"]()

  /// make a reveal request
  vgsShow.request(path: "post",
                method: .post,
               payload: customPayload) { (requestResult) in

      switch requestResult {
      case .success(let code):
          self.copyCardNumberButton.isEnabled = true
          print("vgsshow success, code: \(code)")
      case .failure(let code, let error):
          print("vgsshow failed, code: \(code), error: \(error)")
      }
  }
}
```
## Local Testing
To test and verify your integration with VGS directly from your local machine you can use [VGS Satellite](https://github.com/verygoodsecurity/vgs-satellite).
Check our Satellite [integration  guide](https://www.verygoodsecurity.com/docs/vgs-show/ios-sdk/vgs-satellite-integration).

## Demo Application
Demo application for collecting card data on iOS is <a href="https://github.com/verygoodsecurity/vgs-show-ios/tree/main/VGSShowDemoApp">here</a>.

### Releases
To follow `VGSShowSDK` updates and changes check the [releases](https://github.com/verygoodsecurity/vgs-show-ios/releases) page.

### Metrics
VGSShow tracks a few key metrics to understand SDK features usage help us know what areas need improvement. No personal/sensitive information is collected.
You can easily opt-out of metrics collection in `VGSAnalyticsClient`:
```
VGSAnalyticsClient.shared.shouldCollectAnalytics = false
```

## Dependencies
- iOS 10+
- Swift 5

## License
VGSShow iOS SDK is released under the MIT license. [See LICENSE](https://github.com/verygoodsecurity/vgs-show-ios/blob/master/LICENSE) for details.
