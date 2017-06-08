//
//  NotificationService.h
//  ooniprobe
//
//  Created by Lorenzo Primiterra on 07/06/17.
//  Copyright © 2017 Simone Basso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NotificationService : NSObject

+ (void)registerNotifications:(NSString *)token;

@end
