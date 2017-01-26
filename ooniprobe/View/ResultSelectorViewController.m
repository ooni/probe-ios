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
    return [items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    RunButton *viewButton = (RunButton*)[cell viewWithTag:2];
    [viewButton setTitle:NSLocalizedString(@"view", nil) forState:UIControlStateNormal];
    NSString *content = [items objectAtIndex:indexPath.row];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    title.text = [NSString stringWithFormat:@"%@", [json objectForKey:@"input"]];
    if ([[json objectForKey:@"test_keys"] objectForKey:@"blocking"] != [NSNull null]){
        if (![[[json objectForKey:@"test_keys"] objectForKey:@"blocking"] boolValue])
            title.textColor = color_off_black;
        else title.textColor = color_bad_red;
    }
    else title.textColor = color_bad_red;
    return cell;
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
        NSData *data = [nextTest dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [vc setTestName:[json objectForKey:@"input"]];
    }
}

@end
