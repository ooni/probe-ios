// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "RunTestViewController.h"

@interface RunTestViewController ()

@end

@implementation RunTestViewController
@synthesize testName, testArguments, testDescription;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTestUI) name:@"reloadTable" object:nil];

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
    
    [self reloadTestUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    header.textLabel.font = [UIFont fontWithName:@"FiraSansOT-Bold" size:18];
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
    [current run];
    [self dismissViewControllerAnimated:TRUE completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
    }];
}

@end
