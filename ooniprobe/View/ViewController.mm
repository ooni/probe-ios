// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ViewController.h"

/*Include header from test*/
#include "measurement_kit/ooni.hpp"

#include "measurement_kit/common.hpp"

@implementation ViewController : UIViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    self.availableNetworkMeasurements = [[NSMutableArray alloc] init];
    [self loadAvailableMeasurements];
    self.runningNetworkMeasurements = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:) name:@"refreshTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast) name:@"showToast" object:nil];
    [self setLabels];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_run"]){
        [self performSegueWithIdentifier:@"showInformedConsent" sender:self];
    }
}

- (void) loadAvailableMeasurements {
    DNSInjection *dns_injectionMeasurement = [[DNSInjection alloc] init];
    [self.availableNetworkMeasurements addObject:dns_injectionMeasurement];
    
    TCPConnect *tcp_connectMeasurement = [[TCPConnect alloc] init];
    [self.availableNetworkMeasurements addObject:tcp_connectMeasurement];
    
    HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
    [self.availableNetworkMeasurements addObject:http_invalid_request_lineMeasurement];
    
    WebConnectivity *web_connectivityMeasurement = [[WebConnectivity alloc] init];
    [self.availableNetworkMeasurements addObject:web_connectivityMeasurement];
    
    NdtTest *ndt_testMeasurement = [[NdtTest alloc] init];
    [self.availableNetworkMeasurements addObject:ndt_testMeasurement];
}

-(void)refreshTable:(NSNotification *)notification{
    NetworkMeasurement *current  = (NetworkMeasurement*)[notification object];
    [self.runningNetworkMeasurements removeObject:current];
    [self.tableView reloadData];
}

-(void)reloadTable{
    [self.tableView reloadData];
}
- (void) setLabels {
    [self.testing_historyLabel setText:[NSLocalizedString(@"testing_history", nil) uppercaseString]];
    [self.run_testLabel setText:[NSLocalizedString(@"run_test", nil)  uppercaseString]];
    
    [self.dns_injectionLabel setText:[NSLocalizedString(@"dns_injection", nil) uppercaseString]];
    [self.tcp_connectLabel setText:[NSLocalizedString(@"tcp_connect", nil) uppercaseString]];
    [self.http_invalid_request_lineLabel setText:[NSLocalizedString(@"http_invalid_request_line", nil) uppercaseString]];
    [self.web_connectivityLabel setText:[NSLocalizedString(@"web_connectivity", nil) uppercaseString]];
    [self.ndt_testLabel setText:[NSLocalizedString(@"ndt_test", nil) uppercaseString]];
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) runTests:(id)sender {
    if (self.selectedMeasurement != nil) {
        [self.selectedMeasurement run];
        [self.runningNetworkMeasurements addObject:self.selectedMeasurement];
        [self unselectAll];
        self.selectedMeasurement = nil;
        [self.tableView reloadData];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [self.runningNetworkMeasurements count];
            break;
        case 1:
            return [[TestStorage get_tests] count]-[self.runningNetworkMeasurements count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"running_tests", @"");
            break;
        case 1:
            sectionName = NSLocalizedString(@"finished_tests", @"");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NetworkMeasurement *current;
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_running" forIndexPath:indexPath];
        current = [self.runningNetworkMeasurements objectAtIndex:indexPath.row];
        UIProgressView *bar = (UIProgressView*)[cell viewWithTag:2];
        [bar setProgress:current.progress animated:NO];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_finished" forIndexPath:indexPath];
        current = [TestStorage get_test_atindex:indexPath.row];
    }
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    [title setText:NSLocalizedString(current.name, nil)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1){
        NetworkMeasurement *current = [TestStorage get_test_atindex:indexPath.row];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TestStorage remove_test_atindex:indexPath.row];
        [self.tableView reloadData];
    }
}


- (void) unselectAll {
    [self.dns_injectionButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.tcp_connectButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.http_invalid_request_lineButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.web_connectivityButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
    [self.ndt_testButton setImage:[UIImage imageNamed:@"not-selected"] forState:UIControlStateNormal];
}

- (IBAction)buttonClick:(id)sender forEvent:(UIEvent *)event {
    UIButton *tappedButton = (UIButton*)sender;
    [self unselectAll];
    [tappedButton setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
    if (tappedButton == self.dns_injectionButton){
        DNSInjection *dns_injectionMeasurement = [[DNSInjection alloc] init];
        self.selectedMeasurement = dns_injectionMeasurement;
    }
    else if (tappedButton == self.tcp_connectButton) {
        TCPConnect *tcp_connectMeasurement = [[TCPConnect alloc] init];
        self.selectedMeasurement = tcp_connectMeasurement;
    }
    else if (tappedButton == self.http_invalid_request_lineButton){
        HTTPInvalidRequestLine *http_invalid_request_lineMeasurement = [[HTTPInvalidRequestLine alloc] init];
        self.selectedMeasurement = http_invalid_request_lineMeasurement;
    }
    else if (tappedButton == self.web_connectivityButton){
        WebConnectivity *web_connectivityMeasurement = [[WebConnectivity alloc] init];
        self.selectedMeasurement = web_connectivityMeasurement;
    }
    else if (tappedButton == self.ndt_testButton){
        NdtTest *ndt_testMeasurement = [[NdtTest alloc] init];
        self.selectedMeasurement = ndt_testMeasurement;
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
        content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        //Cut out the last \n
        if ([content length] > 0) {
            content = [content substringToIndex:[content length]-1];
        }
    }
    return [content componentsSeparatedByString:@"\n"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //This screen is hidden for the moment
    if ([[segue identifier] isEqualToString:@"toLog"]){
        LogViewController *vc = (LogViewController * )segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [vc setTest:[TestStorage get_test_atindex:indexPath.row]];
    }
    else if ([[segue identifier] isEqualToString:@"toResult"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NetworkMeasurement *current = [TestStorage get_test_atindex:indexPath.row];
        NSArray *items = [self getItems:current.json_file];
        ResultViewController *vc = (ResultViewController * )segue.destinationViewController;
        [vc setContent:[items objectAtIndex:0]];
    }
    else if ([[segue identifier] isEqualToString:@"toInputList"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NetworkMeasurement *current = [TestStorage get_test_atindex:indexPath.row];
        ResultSelectorViewController *vc = (ResultSelectorViewController * )segue.destinationViewController;
        [vc setItems:[self getItems:current.json_file]];
    }
    else if ([[segue identifier] isEqualToString:@"toInfo"]){
        TestInfoViewController *vc = (TestInfoViewController * )segue.destinationViewController;
        UIButton *tappedButton = (UIButton*)sender;
        if (tappedButton.tag == 1){
            [vc setFileName:@"dns-injection"];
        }
        else if (tappedButton.tag == 2){
            [vc setFileName:@"tcp-connect"];
        }
        else if (tappedButton.tag == 3){
            [vc setFileName:@"http-invalid-request-line"];
        }
        else if (tappedButton.tag == 4){
            [vc setFileName:@"web-connectivity"];
        }
    }
}

@end
