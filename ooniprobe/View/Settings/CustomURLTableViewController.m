#import "CustomURLTableViewController.h"

@interface CustomURLTableViewController ()

@end

@implementation CustomURLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"custom_url", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"run", nil) style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"url", nil);
    UITextField *textField = [self createTextField];
    cell.accessoryView = textField;
    return cell;
}

- (UITextField*)createTextField{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
    textField.delegate = self;
    textField.backgroundColor = color_off_white;
    textField.font = [UIFont fontWithName:@"FiraSansOT-Bold" size:15.0f];
    textField.textColor = color_off_black;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.inputAccessoryView = keyboardToolbar;
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    url = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

@end
