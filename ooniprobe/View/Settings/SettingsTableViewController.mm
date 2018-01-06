#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@end

@implementation SettingsTableViewController
@synthesize category;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(category, nil);
    
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];

    
    [self reloadSettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)reloadSettings {
    items = [SettingsUtility getSettingsForCategory:category];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

/*-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:@"FiraSansOT-Bold" size:15];
    header.textLabel.textColor = color_off_black;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *current = [items objectAtIndex:indexPath.row];
    if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"bool"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
        else switchview.on = NO;
        cell.accessoryView = switchview;
    }
    else if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"segue"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"textfield"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        NSNumber *time = [[NSUserDefaults standardUserDefaults] objectForKey:current];
        NSDecimalNumber *someNumber = [NSDecimalNumber decimalNumberWithString:[time stringValue]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        UITextField *textField = [self createTextField:[formatter stringFromNumber:someNumber]];
        cell.accessoryView = textField;
    }
    return cell;
}

- (UITextField*)createTextField:(NSString*)text{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    textField.delegate = self;
    textField.backgroundColor = color_off_white;
    textField.font = [UIFont fontWithName:@"FiraSansOT-Bold" size:15.0f];
    textField.textColor = color_off_black;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.text = text;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.inputAccessoryView = keyboardToolbar;
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 2 && indexPath.row == 0){
        if ([textField.text integerValue] < 10){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            [[NSUserDefaults standardUserDefaults] setObject:[f numberFromString:@"10"] forKey:@"max_runtime"];
            [self.tableView reloadData];
            [self.view makeToast:NSLocalizedString(@"max_runtime_low", nil)];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [[NSUserDefaults standardUserDefaults] setObject:[f numberFromString:str] forKey:@"max_runtime"];
    return YES;
}

-(IBAction)setSwitch:(UISwitch *)mySwitch{
    UITableViewCell *cell = (UITableViewCell *)mySwitch.superview;
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    NSString *current = [items objectAtIndex:indexpath.row];
    if (mySwitch.on)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:current];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:current];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self reloadSettings];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *current = [items objectAtIndex:indexPath.row];
    if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"segue"]){
        [self performSegueWithIdentifier:current sender:self];
    }
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
