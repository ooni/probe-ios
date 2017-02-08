// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ResultSelectorViewController.h"

@interface ResultSelectorViewController ()

@end

@implementation ResultSelectorViewController;
@synthesize items, testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(testName, nil);
    testResults = [[NSMutableArray alloc] init];
    for(int i=0;i<[items count];i++)
    {
        NSString *content = [items objectAtIndex:i];
        TestResult *testResult = [TestResult new];
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        testResult.input = [NSString stringWithFormat:@"%@", [json objectForKey:@"input"]];
        int anomaly = [self checkAnomaly:[json objectForKey:@"test_keys"]];
        testResult.anomaly = anomaly;
        [testResults addObject:testResult];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [testResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    RunButton *viewButton = (RunButton*)[cell viewWithTag:2];
    [viewButton setTitle:NSLocalizedString(@"view", nil) forState:UIControlStateNormal];
    TestResult *testResult = [testResults objectAtIndex:indexPath.row];
    title.text = testResult.input;
    if (testResult.anomaly == 0) title.textColor = color_ok_green;
    else if (testResult.anomaly == 1) title.textColor = color_warning_orange;
    else if (testResult.anomaly == 2) title.textColor = color_bad_red;
    return cell;
}

-(int)checkAnomaly:(NSDictionary*)test_keys{
    /*null => anomal = 1,
    false => anomaly = 0,
    stringa (dns, tcp-ip, http-failure, http-diff) => anomaly = 2
     
     Return values:
     0 == OK,
     1 == orange,
     2 == red
    */
    id element = [test_keys objectForKey:@"blocking"];
    int anomaly = 0;
    if ([test_keys objectForKey:@"blocking"] == [NSNull null]) {
         anomaly = 1;
    }
    else if (([element isKindOfClass:[NSString class]])) {
        anomaly = 2;
    }
    return anomaly;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    nextTest = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toResult" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(IBAction)viewTest:(id)sender event:(id)event{
    CGPoint currentTouchPosition = [[[event allTouches] anyObject] locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    nextTest = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toResult" sender:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toResult"]){
        ResultViewController *vc = (ResultViewController * )segue.destinationViewController;
        [vc setContent:nextTest];
        [vc setLog_file:self.log_file];
        [vc setTestName:testName];
    }
}

@end
