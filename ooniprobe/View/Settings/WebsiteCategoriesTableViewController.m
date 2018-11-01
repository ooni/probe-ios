#import "WebsiteCategoriesTableViewController.h"

@interface WebsiteCategoriesTableViewController ()

@end

@implementation WebsiteCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings.Websites.Categories.Label", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    categories = [SettingsUtility getSitesCategories];
    categories_disabled = [SettingsUtility getSitesCategoriesDisabled];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *current = [categories objectAtIndex:indexPath.row];
    NSString *categoryTitle = [NSString stringWithFormat:@"CategoryCode.%@.Name", current];
    cell.textLabel.text = NSLocalizedString(categoryTitle, nil);
    cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"category_%@", current]];
    cell.detailTextLabel.textColor = [UIColor colorWithRGBHexString:color_gray5 alpha:1.0f];
    NSString *categoryDescription = [NSString stringWithFormat:@"CategoryCode.%@.Description", current];
    cell.detailTextLabel.text = NSLocalizedString(categoryDescription, nil);
    
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
    if ([categories_disabled containsObject:current]) switchview.on = NO;
    else switchview.on = YES;
    cell.accessoryView = switchview;

    return cell;
}

-(IBAction)setSwitch:(UISwitch *)mySwitch{
    UITableViewCell *cell = (UITableViewCell *)mySwitch.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *current = [categories objectAtIndex:indexPath.row];
    [SettingsUtility addRemoveSitesCategory:current];
}

@end
