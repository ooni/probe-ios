#import "WebsiteCategoriesTableViewController.h"

@interface WebsiteCategoriesTableViewController ()

@end

@implementation WebsiteCategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"website_categories", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    categories = [SettingsUtility getSitesCategories];
    categories_enabled = [SettingsUtility getSitesCategoriesEnabled];
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
    cell.textLabel.text = NSLocalizedString(current, nil);
    cell.imageView.image = [UIImage imageNamed:current];
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
