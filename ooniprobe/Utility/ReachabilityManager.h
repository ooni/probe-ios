//
//  ReachabilityManager.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 14/06/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "NotificationService.h"

@interface ReachabilityManager : NSObject

@property (strong, nonatomic) Reachability *reachability;
+ (ReachabilityManager *)sharedManager;
- (NSString*)getStatus;
@end
