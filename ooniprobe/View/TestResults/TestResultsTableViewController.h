#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Measurement.h"
#import "Result.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ResultsHeaderViewController.h"
#import "TestSummaryTableViewController.h"
#import "TestResultTableViewCell.h"

@interface TestResultsTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ReloadFilterDelegate> {
    NSArray *keys;
    NSDictionary *resultsDic;
    SRKQuery *query;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableFooterConstraint;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SRKResultSet* results;

@end
