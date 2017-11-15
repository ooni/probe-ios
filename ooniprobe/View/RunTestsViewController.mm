#import "RunTestsViewController.h"

@interface RunTestsViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation RunTestsViewController : UITableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    self.revealViewController.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] isEqualToString:@"ar"]){
        [self.revealViewController setRightViewRevealWidth:260.0f];
        self.revealViewController.rightPresentViewHierarchically = YES;
        [self.revealButtonItem setAction: @selector(revealRightView)];
    }
    else {
        [self.revealButtonItem setAction: @selector(revealLeftView)];
        self.revealViewController.leftPresentViewHierarchically = YES;
    }
    self.revealViewController.toggleAnimationType = PBRevealToggleAnimationTypeSpring;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"updateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToastConfiguration) name:@"showToastConfiguration" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:@"showToastTestFinished" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    currentTests = [Tests currentTests];
    self.title = NSLocalizedString(@"run_tests", nil);
    [self reloadTable];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_run"]){
        [self performSegueWithIdentifier:@"showInformedConsent" sender:self];
    }
}

- (BOOL)revealControllerPanGestureShouldBegin:(PBRevealViewController *)revealController direction:(PBRevealControllerPanDirection)direction
    {
        if (direction == PBRevealControllerPanDirectionRight && [[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] isEqualToString:@"ar"]) {
            return NO;
        }
        return YES;
    }
    
- (void)reloadTable{
    if ([TestStorage new_tests]){
        self.navigationItem.leftBarButtonItem.badgeValue = @" ";
        self.navigationItem.leftBarButtonItem.badgeBGColor = color_ok_green;
    }
    [self.tableView reloadData];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runTests:(id)sender event:(id)event {
    CGPoint currentTouchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    NetworkMeasurement *current = [currentTests.availableNetworkMeasurements objectAtIndex:indexPath.row];
    [current setMax_runtime:YES];
    current.inputs = [[TestLists sharedTestLists] getUrls];
    [current run];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentTests.availableNetworkMeasurements count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NetworkMeasurement *current;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_test" forIndexPath:indexPath];
    current = [currentTests.availableNetworkMeasurements objectAtIndex:indexPath.row];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *subtitle = (UILabel*)[cell viewWithTag:2];
    UIImageView *image = (UIImageView*)[cell viewWithTag:3];
    RunButton *runTest = (RunButton*)[cell viewWithTag:4];
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[cell viewWithTag:5];
    UIProgressView *bar = (UIProgressView*)[cell viewWithTag:6];
    [title setText:NSLocalizedString(current.name, nil)];
    NSString *test_desc = [NSString stringWithFormat:@"%@_desc", current.name];
    [subtitle setText:NSLocalizedString(test_desc, nil)];
    [runTest setTitle:NSLocalizedString(@"run", nil) forState:UIControlStateNormal];
    [image setImage:[UIImage imageNamed:current.name]];
    if (current.running){
        [bar setHidden:NO];
        [bar setProgress:current.progress animated:NO];
        [subtitle setHidden:YES];
        [indicator setHidden:FALSE];
        [runTest setHidden:TRUE];
        [indicator startAnimating];
    }
    else {
        [bar setHidden:YES];
        [subtitle setHidden:NO];
        [indicator setHidden:TRUE];
        [runTest setHidden:FALSE];
        [indicator stopAnimating];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)showToastConfiguration{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = color_off_white;
    style.backgroundColor = color_ok_green;
    style.titleFont = [UIFont fontWithName:@"FiraSansOT-Bold" size:15];
    [self.view makeToast:NSLocalizedString(@"ooniprobe_configured", nil) duration:3.0 position:CSToastPositionBottom style:style];
}

-(void)showToast:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *test_name = [userInfo objectForKey:@"test_name"];
    [self.view makeToast:[NSString stringWithFormat:NSLocalizedString(@"test_name_finished", nil), NSLocalizedString(test_name, nil)]];
}

-(NSArray*)getItems:(NSString*)json_file{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:json_file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *content = @"";
    if([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        //Cut out the last \n
        if ([content length] > 0) {
            content = [content substringToIndex:[content length]-1];
        }
    }
    return [content componentsSeparatedByString:@"\n"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"toInfo"]){
        TestInfoViewController *vc = (TestInfoViewController * )segue.destinationViewController;
        NetworkMeasurement *current = [currentTests.availableNetworkMeasurements objectAtIndex:indexPath.row];
        [vc setTestName:current.name];
    }
}

@end
