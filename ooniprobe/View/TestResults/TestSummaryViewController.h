#import <UIKit/UIKit.h>
#import "HeaderSwipeViewController.h"
#import "Result.h"
#import "Measurement.h"
#import "LogViewController.h"
#import "TestRunningViewController.h"
#import "TestDetailsViewController.h"
#import "MessageUtility.h"

@interface TestSummaryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UIColor *defaultColor;
    Measurement *segueObj;
    NSString *segueType;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadBarFooterConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableFooterConstraint;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Result* result;
@property (nonatomic, strong) SRKResultSet *measurements;
@property (nonatomic, strong) NSArray<NSArray<Measurement *> *> *groupedMeasurements;
@end
