//
//  UIForLumberjack.h
//  ooniprobe
//
//  Created by Norbel Ambanumben on 06/09/2022.
//  Copyright © 2022 OONI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIForLumberjack : NSObject <DDLogger>

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) UITableView *tableView;

- (void)showLogInView:(UIView *)view;
- (void)hideLog;
- (void)clearLog;

@end

NS_ASSUME_NONNULL_END
