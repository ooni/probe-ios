//
//  VersionUtility.m
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 24/09/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import "VersionUtility.h"

@implementation VersionUtility

+ (NSString*)get_software_version{
    // FIXME: this breaks OONI backend so we don't send the build number
    /*
    return [NSString stringWithFormat:@"%@%@+%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], release_name, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
     */
    return [NSString stringWithFormat:@"%@%@",
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
            release_name];

}
@end
