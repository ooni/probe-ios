#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Measurement.h"
#import "Result.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ResultsHeaderViewController.h"

@interface TestResultsTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ReloadFilterDelegate>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) SRKResultSet* results;

@end
