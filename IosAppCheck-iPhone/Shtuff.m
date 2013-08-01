//
//  Shtuff.m
//
//
//  Created by Weston Turney-Loos on 12/7/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <openssl/hmac.h>
#import "Shtuff.h"

@implementation Shtuff: NSObject


+ (NSString) sha512Hmac: (NSString*) h
{
    HMAC_CTX ctx;
    unsigned char hmac_value[EVP_MAX_MD_SIZE];
    
    
    int hmac_len;
    char key[] = "etaonrishdlcupfm";
    HMAC_CTX_init(&ctx);
    HMAC_Init_ex(&ctx, key, strlen(key), EVP_sha512(), NULL); /* Process input stream */
    if (!HMAC_Update(&ctx, h, h.length))
        exit(3);
    
    if(!HMAC_Final(&ctx, hmac_value, &hmac_len))
        exit(4);
    
    HMAC_CTX_cleanup(&ctx);
    
    NSString* j = null;
    for(int i = 0; i < hmac_len; i++)
        [j appendFormat:@"%02X", hmac_value[i]];
    
    return j;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(FIPS_mode_set(1)) {
        NSLog(@"FIPS MODE ENABLED");
    } else {
        ERR_load_crypto_strings();
        ERR_print_errors_fp(stderr);
        exit(1);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
