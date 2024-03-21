#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Measurement.h"
#import "Result.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ResultsHeaderViewController.h"
#import "TestSummaryViewController.h"
#import "TestResultTableViewCell.h"

@interface TestResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ReloadFilterDelegate> {
    NSMutableArray *keys;
    NSMutableDictionary *resultsDic;
    SRKQuery *query;
    uint64_t totalResults;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableFooterConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadbarFooterConstraint;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SRKResultSet* results;

- (void)loadMore;
@end
