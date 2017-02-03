// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import "ResultViewController.h"
#import "RunButton.h"
#import "Tests.h"
#import "TestResult.h"

@interface ResultSelectorViewController : UITableViewController {
    NSString *nextTest;
    NSMutableArray *testResults;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) IBOutlet NSString *testName;
@property (nonatomic, strong) NSString *log_file;

@end
