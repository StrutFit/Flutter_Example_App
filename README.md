# StrutFit Flutter Example App
This repository demonstrates how to use the StrutFit Android and iOS SDKs in a Flutter application.  
We would recommend reading the README files for the [Android SDK](https://github.com/StrutFit/AndroidSDK) and the [iOS SDK](https://github.com/StrutFit/iOSSDK) first.  
This README will walk you through how to use this repository as a reference when integrating StrutFit into your own Flutter application.

## A. Dart Code
Firstly you should write the Dart code necessary to interact with the native code you will be writing in the next steps.  
You will need to write code in two places in your application: the Product Display Page and the Order Completion code.  

1. In our example application, our Product Display Page is in the **product_detail_page.dart** file.  
In your Product Display Page code you should initialize the creationParams object with the required data, and then create the StrutFit button view container.  
The important parameters for creationParams are the **organizationId** and the **productCode**, while the others are optional. You can adjust the width and height of the button as you like, but you will want to make sure the contained text is not cut off.  
The important code to include is shown below:  

   ```dart
    final creationParams = {
      'organizationId': 5, // Your organization id
      'productCode': product['productCode'], // the product's unique code
      'sizeUnit': 'US', // optional
      'apparelSizeUnit': 'US', //optional
    };
    ...
    Container(
      width: 500, // Width of StrutFit button
      height: 60, // Height of StrutFit button
      alignment: Alignment.center,
      child: Platform.isAndroid
          ? AndroidView(
              key: UniqueKey(),
              viewType: 'strutfit_button_view',
              layoutDirection: TextDirection.ltr,
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
            )
          : UiKitView(
              key: UniqueKey(),
              viewType: 'strutfit_button_view',
              layoutDirection: TextDirection.ltr,
              creationParams: {
                ...creationParams,
                'key': DateTime.now()
                    .millisecondsSinceEpoch
                    .toString()
              },
              creationParamsCodec: const StandardMessageCodec(),
            ),
    ),
   ...
    ```
2. In our example application, the **product_list_page.dart** file has a button which triggers the StrutFit order tracking on click.  
You should already have some code that executes when a user successfully completes an order in the app.  
You will want to implement your own version of the function below, which is then called on a successful order.  
You should ensure that all of the order details are accurate and using the correct variables in your code. 

   ```dart
   Future<void> triggerTrackingPixel() async {
    final orderDetails = {
      'organizationId': 5, // your organization id
      'orderReference':
          'ORDER-${DateTime.now().millisecondsSinceEpoch}', // the unique order reference for the order (you should already have something like this for your order tracking)
      'orderValue': 399.99, // total order value
      'currencyCode': 'USD',
      'userEmail': 'customer@example.com', // optional
      'items': products.map((product) {
        return {
          'productIdentifier':
              product['productCode'], // the product's unique code
          'price': 99.99, // price per item purchased
          'quantity': 1,
          'size': '10 US', // can be split into size and sizeUnit if preferred
        };
      }).toList()
    };

    try {
      final result =
          await platform.invokeMethod('registerOrderForStrutFit', orderDetails);
      print('Tracking Pixel Response: $result');
    } catch (e) {
      print('Failed to send tracking pixel: $e');
    }
   }
    ```
That's all for the Dart code! Next we will look at the Android platform code. Note: We will walk through testing in section D. 

## B. Android Code
For the Android platform code you need to write code to communicate between the StrutFit SDK and the Dart code you wrote in the previous step.  
In the following steps we will be working in the **android** folder of your Flutter project.

1. First, you will need to add some configuration.  
You can search for **STRUTFIT_CONFIG_CODE** in this example app see what we have done.  
You will need to make changes in the following files:
 - **app/build.gradle:** Ensure the minSdk is 24 or higher & add the following dependency - fit.strut:strutfit-android-sdk at version **8.1.0**:
    ```gradle
    dependencies {
      implementation 'fit.strut:strutfit-android-sdk:8.1.0'
    }
    ```
 - **app/src/main/AndroidManifest.xml:** Add the following feature and permissions:
    ```xml
    <uses-feature
        android:name="android.hardware.camera"
        android:required="false" />
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32"/>
    ```
    Also note down the android namespace in the **app/build.gradle** file (this is com.example.flutter_example_app in our example).

2. Sync the project using Gradle. The simplest way to do this is to open the **android** folder in Android Studio and click on the Sync prompt. You may also use the command line to do this.

3. Copy and paste the files from the **kotlin/com/example/flutter_example_app** folder into the corresponding folder in your Flutter application's **kotlin** directory.  
If your Flutter application is configured to use Java instead of Kotlin, you just need to convert the Kotlin code into its equivalent Java code and put the files in the **java** directory instead.  
The files you should copying across are:
- **MainActivity:** You should already have this file, it is used for configuring the two managers. If you are using it for other things, you can simply add the StrutFit code into the configureFlutterEngine method.
- **StrutFitButtonManager:** Used for displaying the StrutFit button.
- **StrutFitTrackingManager:** Used for sending order information to StrutFit.

    You shouldn't need to edit the logic in these files at all.  

That's all of the Android code done! Next we will move on to iOS.

## C. iOS Code
For the iOS platform code you need to write code to communicate between the StrutFit SDK and the Dart code you wrote in section A.  
In the following steps we will be working in the **ios** folder of your Flutter project.

1. First, you will need to add some configuration.  
You can search for **STRUTFIT_CONFIG_CODE** in this example app see what we have done.  
You will need to make changes in the following file:
 - **Runner/Info.plist:** Add the following code (or add this data via the XCode UI):
    ```xml
  	<key>NSCameraUsageDescription</key>
  	<string>We need camera access to measure your feet for a personalized fit.</string>
  
  	<key>NSPhotoLibraryUsageDescription</key>
  	<string>We need access to your photo library to upload images for size recommendations.</string>
    ```
    You will also need to import the **StrutFit/iOSSDK** package. The easiest way to do this is to open the **ios** folder in XCode and click on the Runner project. Then under Package Dependencies, add a new package. You can find the StrutFit SDK by entering https://github.com/StrutFit/iOSSDK into the search box. Then ensure you are getting version **7.2.0** and that you are adding it to the Runner target. 
    Also note down the product bundle identifier, which can be found in the Build Settings of the Runner target in XCode (this is com.example.flutterExampleApp in our example).

2. Copy and paste the swift files from the **Runner** folder into the same folder in your Flutter application.  
The files you should copying across are:
- **AppDelegate:** You should already have this file, it is used for configuring the two managers. If you are using it for other things, you can simply add the StrutFit code into the application method and add the getFlutterViewController method.
- **StrutFitButtonManager:** Used for displaying the StrutFit button.
- **StrutFitTrackingManager:** Used for sending order information to StrutFit.

    You shouldn't need to edit the logic in these files at all.  

That's all of the iOS code done! Now all we need to do is test.

## D. Testing
To start testing, we need to ensure that the StrutFit system is properly configured for your organization. Your account manager should be able to assist you with this. 

1. Give the android namespace and the iOS product bundle identifier that you noted in the previous sections to your account manager. They will use these values to whitelist your application in the StrutFit system.
2. Check with your account manager that any products that you wish to test with have been added to the StrutFit system.

That should be all you need to test your application. You will want to check the following: 
- Your application runs as ususal
- The StrutFit button appears on products that you expect it to
- The StrutFit button does not appear on products that you expect it to be hidden on
- When an order is completed, it then shows up in the StrutFit system (your account manager can help with this)
- Everything works for both Android and iOS devices

Once you are happy with your testing and you are going to release your changes to production, let your account manager know so that they can make sure any dummy orders you have created so far are ignored going forward.   

## Notes on current limitations: 
- The StrutFit button must have a fixed height and width (both Android and iOS). This also means that when the StrutFit button is not displayed you will end up with empty space where the button would usually be.

If you experience any issues, please speak with your account manager, or contact us at dev@strut.fit.
