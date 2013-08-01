//
//  IosAppCheck-simulator.m
//  IosAppCheck-simulator
//
//  Created by Robert Kayl on 9/17/11.
//  Copyright 2011 T2. All rights reserved.
//

#import "IosAppCheck-simulator.h"
#import <dlfcn.h>
#import <mach-o/dyld.h>
#include <fcntl.h>
#import <CommonCrypto/CommonDigest.h>
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

@implementation IosAppCheck_simulator

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(BOOL) b: (NSBundle*) bundle {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString* bundlePath = [bundle bundlePath];
    NSString* file = [bundle executablePath];
	NSString* path = [NSString stringWithFormat:@"%@/Info.plist", bundlePath];
	NSString* path2 = [NSString stringWithFormat:@"%@/%@", bundlePath, file];
    NSDate* infoModifiedDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileModificationDate];
	NSDate* infoModifiedDate2 = [[[NSFileManager defaultManager] attributesOfItemAtPath:path2 error:nil] fileModificationDate];
	NSDate* pkgInfoModifiedDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"PkgInfo"] error:nil] fileModificationDate];
    
	if(([infoModifiedDate timeIntervalSinceReferenceDate] - [pkgInfoModifiedDate timeIntervalSinceReferenceDate] > 180) || ([infoModifiedDate2 timeIntervalSinceReferenceDate] - [pkgInfoModifiedDate timeIntervalSinceReferenceDate] > 180))
        return FALSE;
    else
        return TRUE;
    [pool release];
    
}


+(BOOL) r: (NSBundle*) bundle {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDictionary *info = [bundle infoDictionary];
    if ([info objectForKey: @"SignerIdentity"] != nil)
        return FALSE;
    else
        return TRUE;
    [pool release];
    
}



+(BOOL) k {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL isFound = TRUE;
    NSArray *path = [NSArray arrayWithObjects:
                     @"/Applications/Cydia.app",
                     @"/Applications/Crackulous.app",
                     @"/Applications/WinterBoard.app",
                     @"/Applications/SBSettings.app",
                     @"/Applications/MxTube.app",
                     @"/Applications/IntelliScreen.app",
                     @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                     @"/Library/MobileSubstrate/DynamicLibraries/WinterBoard.plist",
                     @"/Library/MobileSubstrate/DynamicLibraries/ultrasn0w.plist",
                     @"/Applications/FakeCarrier.app",
                     @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                     @"/private/var/lib/apt",
                     @"/Applications/blackra1n.app",
                     @"/private/var/stash",
                     @"/private/var/mobile/Library/SBSettings/Themes",
                     @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                     @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                     @"/System/Library/LaunchDaemons/com.saurik.afpd.dns-sd.plist",
                     @"/private/var/tmp/cydia.log",
                     @"/private/var/tmp/crackulous.txt",
                     @"/private/var/lib/clutch",
                     @"/private/var/lib/cydia", nil];
    
    for(NSString *string in path) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:string]) {
            NSLog(@"File exists is: %s", [string UTF8String]);
            isFound = FALSE;
        }
    }
    
    return isFound;
    [pool release];
    
}


+(BOOL) a {
    
    int groupId = getgid();
    if (groupId <= 10)
        return FALSE;
    else
        return TRUE;
    
}



+(BOOL) l {
    
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    info.kp_proc.p_flag = 0;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    return ( (info.kp_proc.p_flag & P_TRACED) == 0 );
    
}


+(BOOL) y: (NSBundle*) bundle {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString* bundlePath = [bundle bundlePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* file = [NSString stringWithFormat:@"%@/Info.plist", bundlePath ];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:file error:NULL];
    unsigned long long uFileSize = [fileAttributes fileSize];
    NSString* fFileSize = [NSString stringWithFormat:@"%lld", uFileSize];
    NSString* sFileAttr = [fFileSize stringByAppendingString:fFileSize];
    const char *concat_str = [sFileAttr UTF8String];
    unsigned char resultArr[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(concat_str, (CC_LONG)strlen(concat_str), resultArr);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", resultArr[i]];
    NSDictionary* info = [bundle infoDictionary];
    NSString* fileID = [info objectForKey: @"FileID"];
    if ([fileID isEqualToString:hash])
        return TRUE;
    else
        return FALSE;
    
    [pool release];
    
}


+(BOOL) o: (NSBundle*) bundle {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[[bundle bundlePath] stringByAppendingPathComponent:@"_CodeSignature"]];
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:[[bundle bundlePath] stringByAppendingPathComponent:@"_CodeSignature/CodeResources"]];
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:[[bundle bundlePath] stringByAppendingPathComponent:@"ResourceRules.plist"]];
    
    if((fileExists) && (fileExists2) && (fileExists3))
        return TRUE;
    else
        return FALSE;
    [pool release];
    
}



-(void) dealloc {
    [super dealloc];
}


@end
