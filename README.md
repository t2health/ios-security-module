iOS-Security-Module
===================

FUNCTIONAL REQUIREMENT
----------------------
The T2 IosAppCheck security module consists of several checks commonly used to decrypt and crack iOS applications downloaded from the Apple App Store. The procedures to decrypt and crack applications consists of running a debugger, modifying files, and jailbreaking their devices. 

IMPORTANT: The instructions on how to use, source code and XCode setup is at the end of the document.

The checks consists of:
```
+(BOOL) infoOK: (NSBundle*) bundle: Checks the Info.plist file to see if the SignerIdentity key/value pair has been added. This is used to sign applications without paying the annual Apple developer fee.

+(BOOL) filesOK: (NSBundle*) bundle: Checks to see if the _CodeSignature & CodeResources directories exist and the ResourceRules.plist file exist. These three are usually deleted to allow false certificate signing of applications.

+(BOOL) fileDateOK: (NSBundle*) bundle: Checks the modification dates of the application binary and Info.plist files to see if they are more than 3 minutes newer than the package modification date. The package modification date is the date the binary was created, while the application binary and Info.plist files are usually modified for decrypting and cracking.

+(BOOL) phoneOK: This checks to see if /Applications/Cydia.app exists. This is done for jailbreaking a device.

+(BOOL) rootOK: This checks to see if the user running the applicatrion is the root user.

+(BOOL) debuggerOK: This check detaches from a debugger using the ptrace process.

+(BOOL) hashOK: (NSBundle*) bundle: This checks the Info.plist files for the FileID key/value pair. The FileID should match the application checksum created before deployment. Any changes to the application binary will cause the checksum to change.
```

Disclaimer
----------------------
The IosAppCheck security module will not guarantee an experienced user cannot decrypt or crack T2 iOS applications, however, it will slow down an experienced user.   

The build settings Deployment Postprocessing and Stripped Linked Product should be set to YES in the application via XCode. Shown in the “XCode Setup for Projects” section below.

License
-----------------------
IosAppCheckis Licensed under the NASA Open Source License

Copyright © 2009-2013 United States Government as represented by the Chief Information Officer of the National Center for Telehealth and Technology. All Rights Reserved.

Copyright © 2009-2013 Contributors. All Rights Reserved.

THIS OPEN SOURCE AGREEMENT ("AGREEMENT") DEFINES THE RIGHTS OF USE, REPRODUCTION, DISTRIBUTION, MODIFICATION AND REDISTRIBUTION OF CERTAIN COMPUTER SOFTWARE ORIGINALLY RELEASED BY THE UNITED STATES GOVERNMENT AS REPRESENTED BY THE GOVERNMENT AGENCY LISTED BELOW ("GOVERNMENT AGENCY"). THE UNITED STATES GOVERNMENT, AS REPRESENTED BY GOVERNMENT AGENCY, IS AN INTENDED THIRD-PARTY BENEFICIARY OF ALL SUBSEQUENT DISTRIBUTIONS OR REDISTRIBUTIONS OF THE SUBJECT SOFTWARE. ANYONE WHO USES, REPRODUCES, DISTRIBUTES, MODIFIES OR REDISTRIBUTES THE SUBJECT SOFTWARE, AS DEFINED HEREIN, OR ANY PART THEREOF, IS, BY THAT ACTION, ACCEPTING IN FULL THE RESPONSIBILITIES AND OBLIGATIONS CONTAINED IN THIS AGREEMENT.

https://github.com/t2health/ios-security-module/blob/master/NASA-LICENSE.txt


How To Use
----------------------
Needed files:

Hash
libIosAppCheck-v1.0.a
IosAppCheck-simulator.h
IosAppCheck-iPhone.h

Drop these files onto the project:

In the below image, drop the libIosAppCheck-v1.0.a, IosAppCheck-simulator.h, & IosAppCheck-iPhone.h on Tester 1 target, iOS SDK 4.3 (top of project). 

Be sure to have Copy items into destination group’s folder (shown below). This will keep the files with the project.

You should see all three files as shown below.

Copy the Hash binary file to a location of your choosing, but be sure to know the full path to it. This will prevent the binary from being added to the final project when it is build and deployed.

Implement the checker in the app delegate.
Include the headers files based on whether it’s running on the simulator or not.

```
#if TARGET_IPHONE_SIMULATOR
  #import "IosAppCheck-simulator.h"
#else
	#import "IosAppCheck-iPhone.h"
#endif
```

And add this code to the beginning of the application didFinishLaunchingWithOptions.
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
NSBundle *bundle = [NSBundle mainBundle];

    int z = 0;

    #if TARGET_IPHONE_SIMULATOR

        if(![IosAppCheck_simulator r: bundle]) z = 1;

        if(z==0 && ![IosAppCheck_simulator b: bundle]) z = 3;

        if(z==0 && ![IosAppCheck_simulator a]) z = 5;

        if(z==0 && ![IosAppCheck_simulator y: bundle]) z = 6;

        #ifndef DEBUG

            if(z==0 && ![IosAppCheck_simulator l]) z = 7;

        #endif

    

    #else

        if(![IosAppCheck_iPhone r: bundle]) z = 1;

        if(z==0 && ![IosAppCheck_iPhone o: bundle]) z = 2;

        if(z==0 && ![IosAppCheck_iPhone b: bundle]) z = 3;

        if(z==0 && ![IosAppCheck_iPhone k]) z = 4;

        if(z==0 && ![IosAppCheck_iPhone a]) z = 5;

        if(z==0 && ![IosAppCheck_iPhone y: bundle]) z = 6;

        if(z==0 && ![IosAppCheck_iPhone l]) z = 7;

    #endif
if (z !=0) {
// iOSAppCheck caught something.  attach appdelegate to blank viewcontroller.
    	UIViewController *vc = [[UIViewController alloc] init];
    	UIView *v = [[UIView alloc] initWithFrame:self.window.frame];
    	[vc.view addSubview:v];
    	v.backgroundColor = [UIColor clearColor];
    	self.window.backgroundColor = [UIColor clearColor];
    	self.window.rootViewController = vc;
    	self.navigationController.delegate =self;
   	 
    	[self.window makeKeyAndVisible];
    	return YES;
}

```

The following gets added by going to the target and clicking on the “+ Add Build Phase” at the bottom right of the screen and selecting “Add Run Script”:
```
"${PROJECT_DIR}/${PRODUCT_NAME}/Hash" "${PROJECT_DIR}/${PRODUCT_NAME}/${PRODUCT_NAME}-Info.plist" "${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Info.plist"
```

NOTE: Put the Hash binary in ${PROJECT_DIR}/${PRODUCT_NAME} But do not add it to the project, you do not want it being added to the bundle when you build the project.

Select “Build” twice to make sure.
To know that it worked, you will get “Build Succeeded” both times and see a FileID in the <PROJECT_NAME>-Info.plist.



XCode Setup for Projects
--------------------------
Under the build setting of the project, set the Deployment Postprocessing and Strip Linked Product values to YES. Both must be set for debugging references to be removed from the application binary. This makes the job tougher to debug a binary.		

