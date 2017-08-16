//
//  DictionaryUtility.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 06/08/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryUtility : NSObject

+ (NSDictionary *)parseQueryString:(NSString *)query;
+ (NSDictionary*)getParametersFromDict:(NSDictionary*)dict;
@end
