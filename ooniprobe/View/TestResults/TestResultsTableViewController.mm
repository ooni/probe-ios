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
    for (int i = 0; i< 25; i++){
        int lowerBound = 0;
        int upperBound = 31557600;
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        Result *r = [Result new];
        [r setStartTime:[NSDate dateWithTimeIntervalSinceNow:rndValue]];
        [r setName:@"instant_messaging"];
        [r commit];
    }
     */
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
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM";
    for (Result *current in results){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *key = [df stringFromDate:current.startTime];
        if ([dic objectForKey:key])
            arr = [[dic objectForKey:key] mutableCopy];
        [arr addObject:current];
        [dic setObject:arr forKey:key];
        /*
         build a dictionary like
         17-07
         17-08
         18-01
         */
        //NSLog(@"%@", [df stringFromDate:current.startTime]);
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:NO selector:@selector(localizedStandardCompare:)];
    //NSArray *sortedKeys = [[dic allKeys] sortedArrayUsingSelector: @selector(compare:)];
    keys = [[dic allKeys] sortedArrayUsingDescriptors:@[ descriptor ]];
    resultsDic = dic;
    //NSLog(@"STODIC %@", sortedKeys);

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *month = [keys objectAtIndex:section];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM";
    NSDate *convertedDate = [df dateFromString:month];
    df.dateFormat = @"MMMM yyyy";
    return [df stringFromDate:convertedDate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[resultsDic objectForKey:[keys objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Result *current = [[resultsDic objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *testIcon = (UIImageView*)[cell viewWithTag:1];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *asnLabel = (UILabel*)[cell viewWithTag:3];
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:4];
    [testIcon setImage:[UIImage imageNamed:current.name]];
    titleLabel.text  = NSLocalizedString(current.name, nil);
    
    //TODO check for null or empty and change the string current.asnName
    NSMutableAttributedString *asnName = [[NSMutableAttributedString alloc] initWithString:@"ASN NAME"];
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
