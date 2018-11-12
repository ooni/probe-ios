#import "TestResultsTableViewController.h"

@interface TestResultsTableViewController ()

@end

@implementation TestResultsTableViewController
@synthesize results;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"TestResults.Overview.Title", nil);
}

-(void)testFilter:(SRKQuery*)newQuery{
    query = newQuery;
    results = [query fetch];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM";
    for (Result *current in results){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSString *key = [df stringFromDate:current.start_time];
        if ([dic objectForKey:key])
            arr = [[dic objectForKey:key] mutableCopy];
        [arr addObject:current];
        [dic setObject:arr forKey:key];
    }
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"" ascending:NO selector:@selector(localizedStandardCompare:)];
    keys = [[dic allKeys] sortedArrayUsingDescriptors:@[ descriptor ]];
    resultsDic = dic;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ooni_empty_state"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = NSLocalizedString(@"TestResults.Overview.NoTestsHaveBeenRun", nil);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"FiraSans-Regular" size:16],
                                 NSForegroundColorAttributeName:[UIColor colorWithRGBHexString:color_gray5 alpha:1.0f]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *month = [keys objectAtIndex:section];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM";
    NSDate *convertedDate = [df dateFromString:month];
    df.dateFormat = @"MMMM yyyy";
    return [[df stringFromDate:convertedDate] uppercaseString];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    [header.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:14]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray*)[resultsDic objectForKey:[keys objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Result *current = [[resultsDic objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    TestResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TestResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    [cell setResult:current];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Result *current = [[resultsDic objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [current deleteObject];
        [self testFilter:query];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHeader" object:nil];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

-(IBAction)removeAllTests:(id)sender{
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   for (Result *current in results){
                                       [current deleteObject];
                                   }
                                   [self testFilter:query];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHeader" object:nil];
                               }];
    [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.DoYouWantToDeleteAllTests", nil)
                           message:nil
                          okButton:okButton
                            inView:self];
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"header"]){
        ResultsHeaderViewController *vc = (ResultsHeaderViewController * )segue.destinationViewController;
        [vc setDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"summary"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TestSummaryTableViewController *vc = (TestSummaryTableViewController * )segue.destinationViewController;
        Result *current = [[resultsDic objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        if (!current.is_viewed){
            [current setIs_viewed:YES];
            [current save];
        }
        [vc setResult:current];
    }
}

@end
