#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@end

@implementation SettingsTableViewController
@synthesize category, testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registeredForNotifications)
                                                 name:@"registeredForNotifications"
                                               object:nil];

    if (category != nil)
        self.title = [LocalizationUtility getNameForSetting:category];
    else if (testName != nil)
        self.title = [LocalizationUtility getNameForTest:testName];
    self.navigationController.navigationBar.topItem.title = @"";

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

-(void)reloadSettings {
    if (category != nil)
        items = [SettingsUtility getSettingsForCategory:category];
    else if (testName != nil)
        items = [SettingsUtility getSettingsForTest:testName :YES];
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
    header.textLabel.font = [UIFont fontWithName:@"FiraSans-Regular" size:15];
    header.textLabel.textColor = color_off_black;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *current = [items objectAtIndex:indexPath.row];
    if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"bool"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [LocalizationUtility getNameForSetting:current];
        cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
        //cell.imageView.image = [UIImage imageNamed:current];
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
        else switchview.on = NO;
        cell.accessoryView = switchview;
    }
    else if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"segue"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [LocalizationUtility getNameForSetting:current];
        cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
        //cell.imageView.image = [UIImage imageNamed:current];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"int"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [LocalizationUtility getNameForSetting:current];
        cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
        //cell.imageView.image = [UIImage imageNamed:current];
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:current];
        NSDecimalNumber *someNumber = [NSDecimalNumber decimalNumberWithString:[value stringValue]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        UITextField *textField = [self createTextField:@"int" :[formatter stringFromNumber:someNumber]];
        cell.accessoryView = textField;
    }
    else if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"string"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [LocalizationUtility getNameForSetting:current];
        cell.textLabel.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
        //cell.imageView.image = [UIImage imageNamed:current];
        NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:current];
        UITextField *textField = [self createTextField:@"string" :value];
        cell.accessoryView = textField;
    }
    return cell;
}

//TODO not used now
- (UITextField*)createAlertField:(NSString*)type :(NSString*)text{
    return nil;
}

- (UITextField*)createTextField:(NSString*)type :(NSString*)text{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    textField.delegate = self;
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = [UIFont fontWithName:@"FiraSans-Regular" size:15.0f];
    textField.textColor = [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.text = text;
    if ([type isEqualToString:@"int"])
        textField.keyboardType = UIKeyboardTypeNumberPad;
    else
        textField.keyboardType = UIKeyboardTypeDefault;
    textField.inputAccessoryView = keyboardToolbar;
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

//TODO review these two
- (void)textFieldDidEndEditing:(UITextField *)textField{
    UITableViewCell *cell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *current = [items objectAtIndex:indexPath.row];
    if ([current isEqualToString:@"max_runtime"]){
        if ([textField.text integerValue] < 10){
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            [[NSUserDefaults standardUserDefaults] setObject:[f numberFromString:@"10"] forKey:@"max_runtime"];
            [self.tableView reloadData];
            [self.view makeToast:NSLocalizedString(@"Settings.Error.TestDurationTooLow", nil)];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *current = [items objectAtIndex:indexPath.row];
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([[SettingsUtility getTypeForSetting:current] isEqualToString:@"int"]){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        [[NSUserDefaults standardUserDefaults] setObject:[f numberFromString:str] forKey:current];
    }
    else
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:current];
    return YES;
}

-(IBAction)setSwitch:(UISwitch *)mySwitch{
    UITableViewCell *cell = (UITableViewCell *)mySwitch.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *current = [items objectAtIndex:indexPath.row];
    //TODO-ART how to behave in case of automated_testing_enabled, enable notification automatically?
     if ([current isEqualToString:@"notifications_enabled"]){
         if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]){
             //or if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
             //https://stackoverflow.com/questions/1535403/determine-on-iphone-if-user-has-enabled-push-notifications
             //TODO enable notifications of one or other type (Ex. not send token)
             [MessageUtility notificationAlertinView:self];
             [mySwitch setOn:FALSE];
             return;
         }
    }
    if (!mySwitch.on && ![self canSetSwitch]){
        [mySwitch setOn:TRUE];
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.CantDeactivate", nil) message:nil inView:self];
        return;
    }
    
    if (mySwitch.on)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:current];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:current];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    //TODO when enable remote notification send something to backend
    //TODO hide rows smooth XD
    [self reloadSettings];
}

- (void)registeredForNotifications {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notifications_enabled"];
    [self reloadSettings];
}

-(BOOL)canSetSwitch{
    if (testName != nil){
        NSArray *items = [SettingsUtility getSettingsForTest:testName :NO];
        NSUInteger numberOfTests = [items count];
        if ([testName isEqualToString:@"performance"] || [testName isEqualToString:@"middle_boxes"] || [testName isEqualToString:@"instant_messaging"]){
            for (NSString *current in items){
                if (![[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue])
                    numberOfTests--;
            }
            if (numberOfTests < 2)
                return NO;
            return YES;
        }
        return YES;
    }
    return YES;
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
