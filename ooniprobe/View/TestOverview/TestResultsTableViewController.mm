#import "TestResultsTableViewController.h"

@interface TestResultsTableViewController ()

@end

@implementation TestResultsTableViewController
@synthesize results;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"test_results", nil);
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
  /*
    SRKResultSet* results = [[[[[Person query]
                                where:@"age = 35"]
                               limit:99]
                              orderBy:@"name"]
                             fetch];
   [[[Person query] where:@"department.name = 'Test Department'"] fetch]
*/
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = NSLocalizedString(@"test_results", nil);
}

-(void)testFilter:(SRKQuery*)query{
    results = [query fetch];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM";
    for (Result *current in results){
        /*
         build a dictionary like
         17-07
         17-08
         18-01
         */
        [df stringFromDate:current.startTime]
        NSLog(@"%@", current.startTime);
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ooni_empty_state"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"past_tests_empty", nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"FiraSans-Regular" size:16],
                                 NSForegroundColorAttributeName:[UIColor colorWithRGBHexString:color_gray alpha:1.0f]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [results count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Result *current = [results objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *testIcon = (UIImageView*)[cell viewWithTag:1];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *asnLabel = (UILabel*)[cell viewWithTag:3];
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:4];
    [testIcon setImage:[UIImage imageNamed:current.name]];
    titleLabel.text  = NSLocalizedString(current.name, nil);
    
    //TODO check for null or empty and change the string
    NSMutableAttributedString *asnName = [[NSMutableAttributedString alloc] initWithString:current.asnName];
    [asnName addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                        range:NSMakeRange(0, asnName.length)];
    NSMutableAttributedString *asnText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [NSString stringWithFormat:@"%@ (%@)", current.asn, current.country]]];
    [asnText addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                          range:NSMakeRange(0, asnText.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:asnName];
    [attrStr appendAttributedString:asnText];
    [asnLabel setAttributedText:attrStr];
    
    //from https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/InternationalizingLocaleData/InternationalizingLocaleData.html
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:current.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    timeLabel.text = localizedDateTime;
    
    return cell;
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"header"]){
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ResultsHeaderViewController *vc = (ResultsHeaderViewController * )segue.destinationViewController;
        [vc setDelegate:self];
        //NSString *current = [categories objectAtIndex:indexPath.row];
        //[vc setTestName:@"performance"];
    }
}

@end
