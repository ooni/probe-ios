// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <Foundation/Foundation.h>

@interface DictionaryUtility : NSObject

+ (NSDictionary *)parseQueryString:(NSString *)query;
+ (NSDictionary*)getParametersFromDict:(NSDictionary*)dict;
@end
