#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Measurement.h"
#import "Result.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ResultsHeaderViewController.h"
#import "TestSummaryTableViewController.h"

@interface TestResultsTableViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ReloadFilterDelegate> {
    NSArray *keys;
    NSDictionary *resultsDic;
}

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) SRKResultSet* results;

@end
