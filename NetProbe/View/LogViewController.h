//
//  LogViewController.h
//  NetProbe
//
//  Created by Lorenzo Primiterra on 10/03/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkMeasurement.h"

@interface LogViewController : UIViewController

@property (nonatomic, strong) NetworkMeasurement *test;
@property (nonatomic, strong) IBOutlet UITextView *logView;

@end
