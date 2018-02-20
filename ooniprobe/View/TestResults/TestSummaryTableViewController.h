#import <UIKit/UIKit.h>
#import "HeaderSwipeViewController.h"
#import "Result.h"
#import "Measurement.h"

@interface TestSummaryTableViewController : UITableViewController {
    UIColor *defaultColor;
}
@property (nonatomic, strong) Result* result;

@end
