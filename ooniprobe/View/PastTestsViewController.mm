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

@implementation PastTestsViewController : UITableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    
    finishedTests = [[TestStorage get_tests_rev] mutableCopy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast) name:@"showToast" object:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:FALSE] forKey:@"new_tests"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"past_tests", nil);
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = nil;
}

-(void)reloadTable{
    [self.tableView reloadData];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [finishedTests count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NetworkMeasurement *current;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_test" forIndexPath:indexPath];
    
    current = [finishedTests objectAtIndex:indexPath.row];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *subtitle = (UILabel*)[cell viewWithTag:2];
    UIImageView *image = (UIImageView*)[cell viewWithTag:3];
    RunButton *viewTest = (RunButton*)[cell viewWithTag:4];
    
    [title setText:NSLocalizedString(current.name, nil)];
    [viewTest setTitle:NSLocalizedString(@"view", nil) forState:UIControlStateNormal];
    
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:[current.test_id doubleValue]];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [subtitle setText:[formatter stringFromDate:timestampDate]];
    
    NSArray *items = [self getItems:current.json_file];
    if ([items count] > 1){
        [image setImage:[UIImage imageNamed:current.name]];
        title.textColor = color_off_black;
    }
    else if ([items count] == 1 && [[items objectAtIndex:0] length] > 0){
        [image setImage:[UIImage imageNamed:current.name]];
        title.textColor = color_off_black;
    }
    else {
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_no", current.name]]];
        title.textColor = color_bad_red;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NetworkMeasurement *current = [finishedTests objectAtIndex:indexPath.row];
    [self goToTest:current];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)viewTest:(id)sender event:(id)event{
    CGPoint currentTouchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    NetworkMeasurement *current = [finishedTests objectAtIndex:indexPath.row];
    [self goToTest:current];
}

-(void)goToTest:(NetworkMeasurement*)current{
    nextTest = current;
    NSArray *items = [self getItems:nextTest.json_file];
    if ([items count] > 1)
        [self performSegueWithIdentifier:@"toInputList" sender:self];
    else if ([items count] == 1 && [[items objectAtIndex:0] length] > 0)
        [self performSegueWithIdentifier:@"toResult" sender:self];
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"no_result", nil) message:NSLocalizedString(@"no_result_msg", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"") otherButtonTitles:nil];
        [alert show];
    }
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
        NetworkMeasurement *current = [finishedTests objectAtIndex:indexPath.row];
        [finishedTests removeObjectAtIndex:indexPath.row];
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
    if ([[segue identifier] isEqualToString:@"toResult"]){
        NSArray *items = [self getItems:nextTest.json_file];
        ResultViewController *vc = (ResultViewController * )segue.destinationViewController;
        [vc setContent:[items objectAtIndex:0]];
        [vc setTestName:nextTest.name];
    }
    else if ([[segue identifier] isEqualToString:@"toInputList"]){
        ResultSelectorViewController *vc = (ResultSelectorViewController * )segue.destinationViewController;
        [vc setItems:[self getItems:nextTest.json_file]];
        [vc setTestName:nextTest.name];
    }
}

@end
