## Reveal Image with VGSShow iOS SDK

With VGSShowSDK you can reveal and view image files. To redact image files you can use [VGSCollectSDK](https://github.com/verygoodsecurity/vgs-collect-ios) 

<p align="center">
		<img src="images/Reveal-image-1.png" width="200" height="450" alt="ios-show-reveal-image-1">    
		<img src="images/Reveal-image-2.png" width="200" height="450" alt="ios-show-reveal-image-2">    
		<img src="images/Reveal-image-3.png" width="200" height="450" alt="ios-show-reveal-image-3">    
</p>

#### Step 1

Go to your <a href="https://dashboard.verygoodsecurity.com/" target="_blank">VGS organization</a> and establish <a href="https://www.verygoodsecurity.com/docs/getting-started/quick-integration#securing-inbound-connection" target="_blank">Inbound connection</a>. For this demo you can import pre-built route configuration:

<p align="center">
<img src="images/dashboard_routs.png" width="600">
</p>

-  Find the **image_configuration.yaml** file inside the app repository and download it.
-  Go to the **Routes** section on the <a href="https://dashboard.verygoodsecurity.com/" target="_blank">Dashboard</a> page and select the **Inbound** tab. 
-  Press **Manage** button at the right corner and select **YAML file**.
-  Choose **image_configuration.yaml** file that you just downloaded and tap on **Save** button to save the route.

#### Step 2

Run  `pod update` in `VGSShowDemoApp`.

#### Step 3

Setup `"<VAULT_ID>"`.

Find `DemoAppConfig.swift` in app and replace `vaultId` constant with your <a href="https://www.verygoodsecurity.com/docs/terminology/nomenclature#vault" target="_blank">vault id</a>.

#### Step 4

Drag and drop `test.png` file to the Photos app on the simulator or take a picture using the camera of your real device. 
Testing on real device is recommended due to possible issues with iOS simulator and Photos app.

#### Step 5

Run VGSShowDemoApp and select `Show Collected Image` row. 
Switch to `Image` tab, press on `Select Image`, choose `Photos Library` and select `test.png`. You can also select `Camera` and take a picture on a real device.
Upload it, then switch to `Show` tab and press `Reveal` button.


