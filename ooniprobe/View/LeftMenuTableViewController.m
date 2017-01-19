// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "LeftMenuTableViewController.h"

@interface LeftMenuTableViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation LeftMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UIView *myNav = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 640, 20)];
    //[myNav setBackgroundColor:color_ooni_blue];
    //[self.revealViewController.view addSubview:myNav];
    _menuItems = @[@"run_tests", @"past_tests", @"settings", @"about"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString([_menuItems objectAtIndex:indexPath.row], nil)];
    //cell.textLabel.text = NSLocalizedString([_menuItems objectAtIndex:indexPath.row], nil);
    //[cell.imageView setImage:[UIImage imageNamed:[_menuItems objectAtIndex:indexPath.row]]];
    if (indexPath.row == 1)
        [cell.imageView setImage:[UIImage imageNamed:@"green_dot"]];
    else
        [cell.imageView setImage:nil];
            //cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}

@end
