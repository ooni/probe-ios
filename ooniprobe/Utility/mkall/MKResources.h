// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.
#ifndef MKResources_h
#define MKResources_h

#import <Foundation/Foundation.h>

@interface MKResources : NSObject

+ (NSString *)getMMDBCountryPath;

+ (NSString *)getMMDBASNPath;

+ (NSString *)getCABundlePath;

@end  // interface MKResources

#endif /* MKResources_h */
