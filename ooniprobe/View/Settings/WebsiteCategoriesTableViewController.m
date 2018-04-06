#import "WebsiteCategoriesTableViewController.h"

@interface WebsiteCategoriesTableViewController ()

@end

@implementation WebsiteCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"categories", nil);
    self.navigationController.navigationBar.topItem.title = @"";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    categories = [SettingsUtility getSitesCategories];
    categories_enabled = [SettingsUtility getSitesCategoriesEnabled];
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
    NSString *categoryTitle = [NSString stringWithFormat:@"CategoryCode.%@.Title", current];
    cell.textLabel.text = NSLocalizedString(categoryTitle, nil);
    cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"category_%@", current]];
    cell.detailTextLabel.textColor = [UIColor colorWithRGBHexString:color_gray5 alpha:1.0f];
    if ([categories_enabled containsObject:current]) cell.detailTextLabel.text = NSLocalizedString(@"enabled", nil);
    else cell.detailTextLabel.text = NSLocalizedString(@"disabled", nil);
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toCategorySettings"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WebsiteCategoryTableViewController *vc = (WebsiteCategoryTableViewController * )segue.destinationViewController;
        NSString *current = [categories objectAtIndex:indexPath.row];
        [vc setCategory:current];
    }
}
@end
