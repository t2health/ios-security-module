//  main.m
//  Hash
//
//  Created by Robert Kayl on 9/15/11.
//  Copyright 2011 T2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


int main (int argc, const char * argv[])
{
    
    if(argc != 3) {
        exit(111);
    }
    else {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString* infoPath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSString* info = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
        NSMutableDictionary* plistData = [[NSMutableDictionary alloc] initWithContentsOfFile:infoPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* file = info;
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
        
        [plistData setValue: hash  forKey:@"FileID"];
        [plistData writeToFile: infoPath atomically: YES];
        [plistData release];
        [pool release];
        
    }
}