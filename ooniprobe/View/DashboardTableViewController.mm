#import "DashboardTableViewController.h"

@interface DashboardTableViewController ()

@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //TODO maybe move function to get all test object into an helper
    items = @[@"web_censorship", @"instant_messaging", @"middle_boxes", @"web_performance"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = NSLocalizedString(@"dashboard", nil);
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *test_name = [items objectAtIndex:indexPath.row];
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *subtitle = (UILabel*)[cell viewWithTag:2];
    [title setText:NSLocalizedString(test_name, nil)];
    NSString *test_desc = [NSString stringWithFormat:@"%@_desc", test_name];
    [subtitle setText:NSLocalizedString(test_desc, nil)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *test_name = [items objectAtIndex:indexPath.row];
    if ([test_name isEqualToString:@"instant_messaging"]){
        [[[IMNetworkTest alloc] init] run];
    }
    else if ([test_name isEqualToString:@"web_censorship"]){
        [[[WCNetworkTest alloc] init] run];
    }
    else if ([test_name isEqualToString:@"middle_boxes"]){
        [[[MBNetworkTest alloc] init] run];
    }
    else if ([test_name isEqualToString:@"web_performance"]){
        [[[WPNetworkTest alloc] init] run];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
