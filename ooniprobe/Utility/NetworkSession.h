//
//  NetworkSession.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 16/03/2020.
//  Copyright © 2020 OONI. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkSession : NSObject
+ (NSURLSession*)getSession;
@end

NS_ASSUME_NONNULL_END
