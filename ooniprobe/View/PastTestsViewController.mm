// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "PastTestsViewController.h"

/*Include header from test*/
#include "measurement_kit/ooni.hpp"

#include "measurement_kit/common.hpp"

@interface PastTestsViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation PastTestsViewController : UIViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
    self.runningMeasurementNames = [[NSMutableArray alloc] init];
    self.runningNetworkMeasurements = [[NSMutableArray alloc] init];
    self.finishedNetworkMeasurements = [[TestStorage get_tests_rev] mutableCopy];
    [self loadAvailableMeasurements];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast) name:@"showToast" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"past_test", nil);
    [self.tableView reloadData];
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

- (void) loadAvailableMeasurements {
    [self.availableNetworkMeasurements removeAllObjects];
    
    WebConnectivity *web_connectivityMeasurement = [[WebConnectivity alloc] init];
    [self.availableNetworkMeasurements addObject:web_connectivityMeasurement];
    
    HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
    [self.availableNetworkMeasurements addObject:http_invalid_request_lineMeasurement];
    
    NdtTest *ndt_testMeasurement = [[NdtTest alloc] init];
    [self.availableNetworkMeasurements addObject:ndt_testMeasurement];
    [self.tableView reloadData];
}

//NOT USED
-(void)refreshTable:(NSNotification *)notification{
    NetworkMeasurement *current  = (NetworkMeasurement*)[notification object];
    NSLog(@"finishedNetworkMeasurements: %@", self.finishedNetworkMeasurements);
    [self.runningMeasurementNames removeObject:current.name];
    [self.runningNetworkMeasurements removeObject:current];
    //Temp fix for this GUI
    self.finishedNetworkMeasurements = [[TestStorage get_tests_rev] mutableCopy];
    //[self.finishedNetworkMeasurements insertObject:current atIndex:0];
    [self.tableView reloadData];
}

-(void)reloadTable{
    [self.tableView reloadData];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runTests:(id)sender event:(id)event {
    CGPoint currentTouchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    NetworkMeasurement *current = [self.availableNetworkMeasurements objectAtIndex:indexPath.row];
    [self.runningMeasurementNames addObject:current.name];
    [self.runningNetworkMeasurements addObject:current];
    [current run];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.finishedNetworkMeasurements count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NetworkMeasurement *current;
    /*if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_test" forIndexPath:indexPath];
        current = [self.availableNetworkMeasurements objectAtIndex:indexPath.row];
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        UILabel *subtitle = (UILabel*)[cell viewWithTag:2];
        UIImageView *image = (UIImageView*)[cell viewWithTag:3];
        RunButton *runTest = (RunButton*)[cell viewWithTag:4];
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[cell viewWithTag:5];
        [title setText:NSLocalizedString(current.name, nil)];
        NSString *test_desc = [NSString stringWithFormat:@"%@_desc", current.name];
        [subtitle setText:NSLocalizedString(test_desc, nil)];
        [runTest setTitle:[NSLocalizedString(@"run", nil) uppercaseString] forState:UIControlStateNormal];
        image.layer.cornerRadius = 20.0;
        image.clipsToBounds = YES;
        if ([self.runningMeasurementNames containsObject:current.name]){
            [indicator setHidden:FALSE];
            [runTest setHidden:TRUE];
            [indicator startAnimating];
        }
        else {
            [indicator setHidden:TRUE];
            [runTest setHidden:FALSE];
            [indicator stopAnimating];
        }
    }
    else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_running" forIndexPath:indexPath];
        current = [self.runningNetworkMeasurements objectAtIndex:indexPath.row];
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        [title setText:NSLocalizedString(current.name, nil)];
        UIProgressView *bar = (UIProgressView*)[cell viewWithTag:2];
        [bar setProgress:current.progress animated:NO];
    }
    else if (indexPath.section == 2){
        */
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_finished" forIndexPath:indexPath];
        
        current = [self.finishedNetworkMeasurements objectAtIndex:indexPath.row];
        UILabel *title = (UILabel*)[cell viewWithTag:1];
        [title setText:NSLocalizedString(current.name, nil)];
        
        UILabel *subTitle = (UILabel*)[cell viewWithTag:3];
        NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:[current.test_id doubleValue]];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [subTitle setText:[formatter stringFromDate:timestampDate]];
        
        UIImageView *status = (UIImageView*)[cell viewWithTag:2];
        NSArray *items = [self getItems:current.json_file];
        if ([items count] > 1)
            [status setImage:[UIImage imageNamed:@"test_multi"]];
        else if ([items count] == 1 && [[items objectAtIndex:0] length] > 0)
            [status setImage:nil];
        else
            [status setImage:[UIImage imageNamed:@"test_aborted"]];
    //}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        [self performSegueWithIdentifier:@"toInfo" sender:self];
    }
    else if (indexPath.section == 2){
        NetworkMeasurement *current = [self.finishedNetworkMeasurements objectAtIndex:indexPath.row];
        NSArray *items = [self getItems:current.json_file];
        if ([items count] > 1)
            [self performSegueWithIdentifier:@"toInputList" sender:self];
        else if ([items count] == 1 && [[items objectAtIndex:0] length] > 0)
            [self performSegueWithIdentifier:@"toResult" sender:self];
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"no_result", nil) message:NSLocalizedString(@"no_result_msg", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil];
            [alert show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2)
        return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2)
        return YES;
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NetworkMeasurement *current = [self.finishedNetworkMeasurements objectAtIndex:indexPath.row];
        [self.finishedNetworkMeasurements removeObjectAtIndex:indexPath.row];
        [TestStorage remove_test:current.test_id];
        [self.tableView reloadData];
    }
}

-(void)showToast{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = [UIColor colorWithRed:60.0/255.0 green:118.0/255.0 blue:61.0/255.0 alpha:1.0];
    style.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:240.0/255.0 blue:216.0/255.0 alpha:1.0];
    [self.view makeToast:NSLocalizedString(@"ooniprobe_configured", nil) duration:3.0 position:CSToastPositionBottom style:style];
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
    //This screen is hidden for the moment
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"toLog"]){
        LogViewController *vc = (LogViewController * )segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [vc setTest:[self.finishedNetworkMeasurements objectAtIndex:indexPath.row]];
    }
    else if ([[segue identifier] isEqualToString:@"toResult"]){
        
        NetworkMeasurement *current = [self.finishedNetworkMeasurements objectAtIndex:indexPath.row];
        NSArray *items = [self getItems:current.json_file];
        ResultViewController *vc = (ResultViewController * )segue.destinationViewController;
        [vc setContent:[items objectAtIndex:0]];
    }
    else if ([[segue identifier] isEqualToString:@"toInputList"]){
        
        NetworkMeasurement *current = [self.finishedNetworkMeasurements objectAtIndex:indexPath.row];
        ResultSelectorViewController *vc = (ResultSelectorViewController * )segue.destinationViewController;
        [vc setItems:[self getItems:current.json_file]];
    }
}

@end
