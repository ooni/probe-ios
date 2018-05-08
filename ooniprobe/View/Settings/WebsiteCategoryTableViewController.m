#import "WebsiteCategoryTableViewController.h"

@interface WebsiteCategoryTableViewController ()

@end

@implementation WebsiteCategoryTableViewController
@synthesize category;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(category, nil);
    categories_enabled = [SettingsUtility getSitesCategoriesEnabled];
    self.navigationController.navigationBar.topItem.title = @"";
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *categoryDescription = [NSString stringWithFormat:@"CategoryCode.%@.Description", category];
    return NSLocalizedString(categoryDescription, nil);
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    NSString *categoryDescription = [NSString stringWithFormat:@"CategoryCode.%@.Description", category];
    [header.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray6 alpha:1.0f]];
    [header.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:16]];
    header.textLabel.text = NSLocalizedString(categoryDescription, nil);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *categoryTitle = [NSString stringWithFormat:@"CategoryCode.%@.Name", category];
    cell.textLabel.text = NSLocalizedString(categoryTitle, nil);
    cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"category_%@", category]];
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
    if ([categories_enabled containsObject:category]) switchview.on = YES;
    else switchview.on = NO;
    cell.accessoryView = switchview;
    return cell;
}

-(IBAction)setSwitch:(UISwitch *)mySwitch{
    [SettingsUtility addRemoveSitesCategory:category];
}

@end
