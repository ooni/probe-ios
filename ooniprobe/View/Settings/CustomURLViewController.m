#import "CustomURLViewController.h"
#import "ReachabilityManager.h"

@interface CustomURLViewController ()

@end

@implementation CustomURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings.Websites.CustomURL.Title", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    
    [self.runButton setTitle:NSLocalizedString(@"Settings.Websites.CustomURL.Run", nil) forState:UIControlStateNormal];

    //hack to override back button action
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    self.urlsList = [[NSMutableArray alloc] init];
    [self.urlsList addObject:@"https://"];
    
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
    [self.urlsList addObject:@"https://"];
    [self.tableView reloadData];
}

-(IBAction)run:(id)sender{
    urlArray = [[NSMutableArray alloc] init];
    for (NSString *url in self.urlsList){
        if (![url isEqualToString:@"http://"] && ![url isEqualToString:@"https://"]){
            Url *currentUrl = [Url checkExistingUrl:url];
            [urlArray addObject:currentUrl.url];
        }
    }
    if ([urlArray count] > 0) {
        if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable){
            [self performSegueWithIdentifier:@"toTestRun" sender:sender];
            [self.navigationController popToRootViewControllerAnimated:NO];
            self.urlsList = nil;
        }
        else
            [MessageUtility alertWithTitle:@"Modal.Error" message:@"Modal.Error.NoInternet" inView:self];
    }
    else
        [MessageUtility showToast:@"Settings.Websites.CustomURL.NoURLEntered" inView:self.view];
}

-(BOOL)hasUrl{
    for (NSString *url in self.urlsList){
        if (![url isEqualToString:@"http://"] && ![url isEqualToString:@"https://"])
            return YES;
    }
    return NO;
}

-(void)back{
    if (![self hasUrl])
        [self.navigationController popViewControllerAnimated:YES];
    else {
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.CustomURL.NotSaved", nil)
                               message:nil
                              okButton:okButton
                                inView:self];

    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.urlsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITextField *textField = (UITextField*)[cell viewWithTag:1];
    UIButton *deleteBtn = (UIButton*)[cell viewWithTag:2];
    if ([self.urlsList count] > 1)
        [deleteBtn setHidden:NO];
    else
        [deleteBtn setHidden:YES];
    textField.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    textField.inputAccessoryView = keyboardToolbar;
    textField.text = [self.urlsList objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)deleteRow:(id)sender{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.urlsList removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.urlsList setObject:[textField.text stringByReplacingCharactersInRange:range withString:string] atIndexedSubscript:indexPath.row];
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toTestRun"]){
        TestRunningViewController *vc = (TestRunningViewController * )segue.destinationViewController;
        WebsitesSuite *testSuite = [[WebsitesSuite alloc] init];
        [testSuite setUrls:urlArray];
        [vc setTestSuite:testSuite];
    }
}
@end
