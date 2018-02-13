#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Measurement.h"
#import "Result.h"
#import "UIScrollView+EmptyDataSet.h"

@interface TestResultsTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) SRKResultSet* results;

@end
