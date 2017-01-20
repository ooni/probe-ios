// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import "LogViewController.h"
#import "ResultViewController.h"
#import "ResultSelectorViewController.h"
#import "TestStorage.h"
#import "UIView+Toast.h"
#import "RunButton.h"
#import "SWRevealViewController.h"
#import "UIButton+Badge.h"

@interface PastTestsViewController : UITableViewController {
    NSMutableArray *finishedTests;
    NetworkMeasurement *nextTest;
}


@end
