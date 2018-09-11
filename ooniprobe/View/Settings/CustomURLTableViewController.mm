#import "CustomURLTableViewController.h"

@interface CustomURLTableViewController ()

@end

@implementation CustomURLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings.Websites.CustomURL", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Settings.Websites.CustomURL.Run", nil) style:UIBarButtonItemStylePlain target:self action:@selector(run:)];
    rows = 1;
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    urls = [[NSMutableDictionary alloc] init];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];

}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addRow:(id)sender{
    rows++;
    [self.tableView reloadData];
}

-(IBAction)run:(id)sender{
    urlArray = [[NSMutableArray alloc] init];
    for (NSString *key in [urls allKeys]){
        if (![[urls objectForKey:key] isEqualToString:@"http://"]){
            Url *currentUrl = [[Url alloc] initWithUrl:[urls objectForKey:key] category:@"MISC" country:@"ZZ"];
            [currentUrl commit];
            [urlArray addObject:[urls objectForKey:key]];
        }
    }
    if ([urlArray count] > 0) {
        [self performSegueWithIdentifier:@"toTestRun" sender:self];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else
        [MessageUtility showToast:@"Settings.Websites.CustomURL.NoURLEntered" inView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Settings.Websites.CustomURL.URL", nil);
    cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    UITextField *textField = [self createTextField];
    if ([urls objectForKey:[NSNumber numberWithInteger:indexPath.row]])
        textField.text = [urls objectForKey:[NSNumber numberWithInteger:indexPath.row]];
    else
        textField.text = @"http://";
    cell.accessoryView = textField;
    return cell;
}

- (UITextField*)createTextField{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    textField.delegate = self;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont fontWithName:@"FiraSans-Regular" size:15.0f];
    textField.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.inputAccessoryView = keyboardToolbar;
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [urls setObject:[textField.text stringByReplacingCharactersInRange:range withString:string] forKey:[NSNumber numberWithInteger:indexPath.row]];
    //url = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        [vc setTestSuiteName:@"websites"];
        [vc setUrls:urlArray];
    }
}
@end
