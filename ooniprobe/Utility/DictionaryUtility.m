#import "DictionaryUtility.h"

@implementation DictionaryUtility

+ (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByRemovingPercentEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
        [dict setObject:val forKey:key];
    }
    return dict;
}

+ (NSDictionary*)getParametersFromDict:(NSDictionary*)dict{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    for (NSString *key in [dict allKeys]){
        NSString *current = [dict objectForKey:key];
        NSError *error;
        NSData *data = [current dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error == nil){
            //set a dictionary subparameter
            [parameters setObject:dictionary forKey:key];
        }
        else{
            //set a string subparameter
            [parameters setObject:current forKey:key];
        }
    }
    return parameters;
}
@end
