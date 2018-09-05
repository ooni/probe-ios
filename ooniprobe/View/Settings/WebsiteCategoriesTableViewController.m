#import "WebsiteCategoriesTableViewController.h"

@interface WebsiteCategoriesTableViewController ()

@end

@implementation WebsiteCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings.AutomatedTesting.Categories.Title", nil);
    self.navigationController.navigationBar.topItem.title = @"";
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
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    UILabel *detail = (UILabel*)[cell viewWithTag:2];

    NSString *current = [categories objectAtIndex:indexPath.row];
    NSString *categoryTitle = [NSString stringWithFormat:@"CategoryCode.%@.Name", current];
    title.text = NSLocalizedString(categoryTitle, nil);
    title.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"category_%@", current]];
    detail.textColor = [UIColor colorWithRGBHexString:color_gray5 alpha:1.0f];

    if ([categories_disabled containsObject:current])
        detail.text = NSLocalizedString(@"Settings.Disabled", nil);
    else
        detail.text = NSLocalizedString(@"Settings.Enabled", nil);
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
