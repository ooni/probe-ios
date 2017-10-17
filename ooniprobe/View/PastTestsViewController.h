#import <UIKit/UIKit.h>
#import "ResultViewController.h"
#import "ResultSelectorViewController.h"
#import "TestStorage.h"
#import "UIView+Toast.h"
#import "RunButton.h"
#import "PBRevealViewController.h"
#import "UIButton+Badge.h"
#import "Tests.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AppDelegate.h"
#import "MessageUtility.h"

@interface PastTestsViewController : UITableViewController <PBRevealViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    NSMutableArray *finishedTests;
    NetworkMeasurement *nextTest;
}


@end
