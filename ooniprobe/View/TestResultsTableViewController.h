#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Measurement.h"
#import "Result.h"

@interface TestResultsTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) SRKResultSet* results;

@end
