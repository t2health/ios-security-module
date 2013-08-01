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
Copyright 2012 The National Center for Telehealth and Technology

IosAppCheckis Licensed under the NASA Open Source License: https://github.com/t2health/T2-Mood-Tracker-iOS/blob/master/NASA-LICENSE.txt


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
#if TARGET_IPHONE_SIMULATOR
  #import "IosAppCheck-simulator.h"
#else
	#import "IosAppCheck-iPhone.h"
#endif

And add this code to the beginning of the application didFinishLaunchingWithOptions.
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	int a = 0;
	NSBundle *bundle = [NSBundle mainBundle];
#if TARGET_IPHONE_SIMULATOR
	if(![IosAppCheck_simulator infoOK: bundle]) a = 1;
	if(a==0 && ![IosAppCheck_simulator filesOK: bundle]) a = 2;    
	if(a==0 && ![IosAppCheck_simulator fileDateOK: bundle]) a = 3;    
	if(a==0 && ![IosAppCheck_simulator phoneOK]) a = 4;    
	if(a==0 && ![IosAppCheck_simulator rootOK]) a = 5;    
#ifndef DEBUG    
	if(a==0 && ![IosAppCheck_simulator debuggerOK]) a = 7;
#endif
	if(a==0 && ![IosAppCheck_simulator hashOK: bundle]) a = 6;    
#else
	if(![IosAppCheck_iPhone infoOK: bundle]) a = 1;
	if(a==0 && ![IosAppCheck_iPhone filesOK: bundle]) a = 2;    
	if(a==0 && ![IosAppCheck_iPhone fileDateOK: bundle]) a = 3;    
	if(a==0 && ![IosAppCheck_iPhone phoneOK]) a = 4;    
	if(a==0 && ![IosAppCheck_iPhone rootOK]) a = 5;    
#ifndef DEBUG    
	if(a==0 && ![IosAppCheck_iPhone debuggerOK]) a = 7;
#endif
if (a !=0) {
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
…. rest of method

The following gets added by going to the target and clicking on the “+ Add Build Phase” at the bottom right of the screen and selecting “Add Run Script”:
```
"${PROJECT_DIR}/${PRODUCT_NAME}/Hash" "${PROJECT_DIR}/${PRODUCT_NAME}/${PRODUCT_NAME}-Info.plist" "${TARGET_BUILD_DIR}/${PRODUCT_NAME}.app/Info.plist"
```
