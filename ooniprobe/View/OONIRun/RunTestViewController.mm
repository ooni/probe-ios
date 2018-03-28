#import "RunTestViewController.h"

@interface RunTestViewController ()

@end

@implementation RunTestViewController
@synthesize testName, testArguments, testDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTestUI) name:@"reloadTable" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTest:) name:@"reloadTest" object:nil];
    //[self configureView];
}

/* EVERYTHING DEPRECATED
-(void)configureView{
    currentTests = [Tests currentTests];
    [self.runButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"run", nil)] forState:UIControlStateNormal];

    if (testDescription != nil)
        [self.titleLabel setText:[NSString stringWithFormat:@"%@", testDescription]];
    else
        [self.titleLabel setText:NSLocalizedString(@"run_test_message", nil)];

    [self.test_detailsLabel setText:NSLocalizedString(@"test_details", nil)];
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    [self.test_titleLabel setText:NSLocalizedString(current.name, nil)];
    [self.test_iconImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_big", current.name]]];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //reset the arrays: we may be called more than once for the same screen
    rows = [[NSArray alloc] init];
    urls = [testArguments objectForKey:@"urls"];
    if ([urls count] > 0){
        showIcon = TRUE;
        rows = urls;
    }
    else if ([current.name isEqualToString:@"web_connectivity"]){
        rows = [NSArray arrayWithObject:NSLocalizedString(@"random_sampling_urls", nil)];
    }
    else {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    
    //reloading the view with new parameters.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [self reloadTestUI];
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadTestUI{
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    //basic case (not running e not started)
    if (!current.running){
        [self.indicator setHidden:TRUE];
        [self.runButton setHidden:FALSE];
        [self.indicator stopAnimating];
    }
    //current test is running
    else {
        [self.indicator setHidden:FALSE];
        [self.runButton setHidden:TRUE];
        [self.indicator startAnimating];
    }
}

-(void)reloadTest:(NSNotification *)notification{
    NSDictionary *parameters = notification.userInfo;
    testName = [parameters objectForKey:@"tn"];
    testArguments = [parameters objectForKey:@"ta"];
    testDescription = [parameters objectForKey:@"td"];
    [self configureView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rows count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([rows count] == 0)
        return nil;
    return NSLocalizedString(@"urls", nil);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([rows count] == 0)
        return 0;
    return 40;

}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView.backgroundColor = [UIColor clearColor];
    header.textLabel.font = [UIFont fontWithName:@"FiraSans-Regular" size:18];
    [header.textLabel setTextColor:color_off_black];
    header.textLabel.text = NSLocalizedString(@"urls", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *current = [rows objectAtIndex:indexPath.row];
    if (showIcon) cell.imageView.image = [UIImage imageNamed:@"include_cc"];
    cell.textLabel.text = current;
    return cell;
}

-(IBAction)run:(id)sender {
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    if ([urls count] > 0){
        current.inputs = urls;
    }
    [current setMax_runtime_enabled:NO];
    [current run];
    [self dismissViewControllerAnimated:TRUE completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
    }];
}
 */

@end
