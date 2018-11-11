// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.

#import "MKResources.h"

@implementation MKResources

+ (NSString *)getMMDBCountryPath {
  return [[NSBundle mainBundle]
    pathForResource:@"country" ofType:@"mmdb"];
}

+ (NSString *)getMMDBASNPath{
  return [[NSBundle mainBundle]
    pathForResource:@"asn" ofType:@"mmdb"];
}

+ (NSString *)getCABundlePath{
  return [[NSBundle mainBundle]
    pathForResource:@"ca-bundle" ofType:@"pem"];
}

@end  // implementation MKResources
