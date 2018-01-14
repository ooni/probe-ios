#import <Foundation/Foundation.h>

@interface DictionaryUtility : NSObject

+ (NSDictionary *)parseQueryString:(NSString *)query;
+ (NSDictionary *)getParametersFromDict:(NSDictionary*)dict;
@end
