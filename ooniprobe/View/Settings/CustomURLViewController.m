#import "CustomURLViewController.h"
#import "ReachabilityManager.h"
#import <QuartzCore/QuartzCore.h>

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
    [self.urlsList addObject:@"http://"];
    
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
    [self.urlsList addObject:@"http://"];
    [self.tableView reloadData];
}

-(IBAction)run:(id)sender{
    //Check if every url has a prefix, otherwise show error.
    if (![self allPrefix]){
        [MessageUtility showToast:NSLocalizedString(@"Settings.Websites.CustomURL.NoURLEntered", nil)
                           inView:self.view];
        [self.tableView reloadData];
        return;
    }
    urlArray = [[NSMutableArray alloc] init];
    for (NSString *url in self.urlsList){
        NSString *sanitizedUrl= [url stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if (![sanitizedUrl isEqualToString:@"http://"] && ![sanitizedUrl isEqualToString:@"https://"]){
            Url *currentUrl = [Url checkExistingUrl:sanitizedUrl];
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
            [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil)
                                   message:NSLocalizedString(@"Modal.Error.NoInternet", nil) inView:self];
    }
    else
        [MessageUtility showToast:NSLocalizedString(@"Settings.Websites.CustomURL.NoURLEntered", nil)
                           inView:self.view];
}

-(BOOL)allPrefix{
    for (NSString *url in self.urlsList){
        if (![self hasPrefix:url])
            return NO;
    }
    return YES;
}

-(BOOL)hasUrl{
    for (NSString *url in self.urlsList){
        if (![url isEqualToString:@"http://"] && ![url isEqualToString:@"https://"])
            return YES;
    }
    return NO;
}

-(BOOL)hasPrefix:(NSString*)url{
    if (![url containsString:@"http://"] && ![url containsString:@"https://"])
        return NO;
    return YES;
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
        [MessageUtility alertWithTitle:nil
                               message:NSLocalizedString(@"Modal.CustomURL.NotSaved", nil)
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
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;

    if ([self.urlsList count] > 1)
        [deleteBtn setHidden:NO];
    else
        [deleteBtn setHidden:YES];
    textField.textColor = [UIColor colorNamed:@"color_gray9"];

    NSString *curUrl = [self.urlsList objectAtIndex:indexPath.row];
    if ([self hasPrefix:curUrl])
        textField.layer.borderColor = [[UIColor colorNamed:@"color_gray7"] CGColor];
    else
        textField.layer.borderColor = [[UIColor colorNamed:@"color_red8"] CGColor];

    textField.inputAccessoryView = keyboardToolbar;
    textField.text = curUrl;
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
        WebConnectivity *test = [[WebConnectivity alloc] init];
        [testSuite setTestList:[NSMutableArray arrayWithObject:test]];
        [test setInputs:urlArray];
        [vc setTestSuites:[NSMutableArray arrayWithObject:testSuite]];
    }
}
@end
