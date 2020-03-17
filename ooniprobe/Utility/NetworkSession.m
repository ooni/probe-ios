//
//  NetworkSession.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 16/03/2020.
//  Copyright © 2020 OONI. All rights reserved.
//

#import "NetworkSession.h"
#import "VersionUtility.h"

@implementation NetworkSession

+ (NSURLSession*)getSession{
    NSURLSessionConfiguration *sessionConf = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString * userAgent  = [NSString stringWithFormat:@"ooniprobe-ios/%@", [VersionUtility get_software_version]];
    sessionConf.HTTPAdditionalHeaders = @{@"User-Agent": userAgent};
    return [NSURLSession sessionWithConfiguration:sessionConf];
}

@end
