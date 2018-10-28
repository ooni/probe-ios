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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];

    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    urls = [[NSMutableArray alloc] init];
    [urls addObject:@"https://"];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];

}

- (void) keyboardWillShow:(NSNotification *)note {
    
    CGSize kbSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    //TODO-2.0 test on iPad and small iPhone
    self.runButton.transform = CGAffineTransformMakeTranslation( 0, -kbSize.height-keyboardToolbar.bounds.size.height-20 );
    [UIView commitAnimations];
}

- (void) keyboardDidHide:(NSNotification *)note {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    self.runButton.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)addRow:(id)sender{
    [urls addObject:@"https://"];
    [self.tableView reloadData];
}

-(IBAction)run:(id)sender{
    urlArray = [[NSMutableArray alloc] init];
    for (NSString *url in urls){
        if (![url isEqualToString:@"http://"] && ![url isEqualToString:@"https://"]){
            Url *currentUrl = [Url checkExistingUrl:url];
            [urlArray addObject:currentUrl.url];
        }
    }
    if ([urlArray count] > 0) {
        if ([[ReachabilityManager sharedManager].reachability currentReachabilityStatus] != NotReachable){
            [self performSegueWithIdentifier:@"toTestRun" sender:sender];
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else
            [MessageUtility alertWithTitle:@"Modal.Error" message:@"Modal.Error.NoInternet" inView:self];
    }
    else
        [MessageUtility showToast:@"Settings.Websites.CustomURL.NoURLEntered" inView:self.view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [urls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    UITextField *textField = (UITextField*)[cell viewWithTag:1];
    textField.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    textField.inputAccessoryView = keyboardToolbar;
    textField.text = [urls objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)deleteRow:(id)sender{
    UIButton *button = (UIButton *)sender;
    UITableViewCell *cell = (UITableViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [urls removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [urls setObject:[textField.text stringByReplacingCharactersInRange:range withString:string] atIndexedSubscript:indexPath.row];
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
