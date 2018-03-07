#import <UIKit/UIKit.h>
#import "HeaderSwipeViewController.h"
#import "Result.h"
#import "Measurement.h"
#import "LogViewController.h"

@interface TestSummaryTableViewController : UITableViewController {
    UIColor *defaultColor;
    Measurement *segueObj;
    NSString *segueType;
}
@property (nonatomic, strong) Result* result;
@property (nonatomic, strong) SRKResultSet *measurements;
@end
