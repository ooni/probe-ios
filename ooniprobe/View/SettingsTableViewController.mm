// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "SettingsTableViewController.h"
#define alert_tag_collector_address 1

@interface SettingsTableViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    self.revealViewController.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode] isEqualToString:@"ar"]){
        [self.revealViewController setRightViewRevealWidth:260.0f];
        self.revealViewController.rightPresentViewHierarchically = YES;
        [self.revealButtonItem setAction: @selector(revealRightView)];
    }
    else {
        [self.revealButtonItem setAction: @selector(revealLeftView)];
        self.revealViewController.leftPresentViewHierarchically = YES;
    }
    self.revealViewController.toggleAnimationType = PBRevealToggleAnimationTypeSpring;
    self.title = NSLocalizedString(@"settings", nil);
    [self reloadSettings];
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker setLocale:[NSLocale currentLocale]];
    NSDate *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_notifications_time"];
    [datePicker setDate:time];
    [datePicker addTarget:self action:@selector(timeChanged:) forControlEvents:UIControlEventValueChanged];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDot) name:@"reloadTable" object:nil];
    [self reloadDot];
}

- (void)reloadDot{
    if ([TestStorage new_tests]){
        self.navigationItem.leftBarButtonItem.badgeValue = @" ";
        self.navigationItem.leftBarButtonItem.badgeBGColor = color_ok_green;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return [notificationItems count];
    else if (section == 1)
        return [privacyItems count];
    return [advancedItems count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"notifications", nil);
    else if (section == 1)
        return NSLocalizedString(@"privacy", nil);
    return NSLocalizedString(@"advanced_settings", nil);
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:@"FiraSansOT-Bold" size:15];
    header.textLabel.textColor = color_off_black;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSString *current = [notificationItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        if ([current isEqualToString:@"local_notifications"]){
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
            else switchview.on = NO;
            cell.accessoryView = switchview;
        }
        else {
            NSDate *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_notifications_time"];
            UITextField *textField = [self createTextField:[dateFormatter stringFromDate:time]];
            textField.inputView = datePicker;
            timeField = textField;
            cell.accessoryView = textField;
        }
    }
    else if (indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSString *current = [privacyItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
        else switchview.on = NO;
        cell.accessoryView = switchview;
    }
    else {
        NSString *current = [advancedItems objectAtIndex:indexPath.row];
        if ([current isEqualToString:@"max_runtime"]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(current, nil);
            cell.imageView.image = [UIImage imageNamed:current];
            NSNumber *time = [[NSUserDefaults standardUserDefaults] objectForKey:current];
            NSDecimalNumber *someNumber = [NSDecimalNumber decimalNumberWithString:[time stringValue]];
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            UITextField *textField = [self createTextField:[formatter stringFromNumber:someNumber]];
            cell.accessoryView = textField;
        }
        else if ([current isEqualToString:@"collector_address"]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSub" forIndexPath:indexPath];
            cell.textLabel.text = NSLocalizedString(current, nil);
            cell.imageView.image = [UIImage imageNamed:current];
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:current];
        }
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
    NSString *current;
    if (indexpath.section == 0)
        current = [notificationItems objectAtIndex:indexpath.row];
    else if (indexpath.section == 1)
        current = [privacyItems objectAtIndex:indexpath.row];
    if (mySwitch.on)
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:current];
    else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:current];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([current isEqualToString:@"upload_results"] || [current isEqualToString:@"local_notifications"]){
        if ([current isEqualToString:@"local_notifications"]) {
            if (mySwitch.on)
                [self showNotification:nil];
            else
                [self cancelScheduledNotifications];
        }
        [self reloadSettings];
    }
}

-(void)reloadSettings {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue]){
        privacyItems = @[@"upload_results", @"include_ip", @"include_asn", @"include_cc", @"send_crash"];
        advancedItems = @[@"max_runtime", @"collector_address"];
    }
    else {
        privacyItems = @[@"upload_results", @"send_crash"];
        advancedItems = @[@"max_runtime"];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"local_notifications"] boolValue])
        notificationItems = @[@"local_notifications", @"local_notifications_time"];
    else
        notificationItems = @[@"local_notifications"];
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row == [advancedItems count] -1){
        NSString *current = [advancedItems objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(current, @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", nil), NSLocalizedString(@"set_default", nil), nil];
        alert.tag = alert_tag_collector_address;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        value = [alert textFieldAtIndex:0];
        value.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"collector_address"];
        value.autocorrectionType = UITextAutocorrectionTypeNo;
        [value setKeyboardType:UIKeyboardTypeURL];
        [alert show];
    }
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == alert_tag_collector_address){
        //collector address
        if (buttonIndex == 1 && value.text.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:value.text forKey:@"collector_address"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }
        else if (buttonIndex == 2){
            [[NSUserDefaults standardUserDefaults] setObject:COLLECTOR_ADDRESS forKey:@"collector_address"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }
    }
}

- (void)showNotification:(NSDate*)fireDate
{
    [self cancelScheduledNotifications];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    if (fireDate == nil) fireDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"local_notifications_time"];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = NSLocalizedString(@"local_notifications_text", nil);
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.repeatInterval = NSCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)cancelScheduledNotifications{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


-(void)timeChanged:(UIDatePicker*)sender{
    [[NSUserDefaults standardUserDefaults] setObject:datePicker.date forKey:@"local_notifications_time"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [timeField setText:[dateFormatter stringFromDate:datePicker.date]];
    [self showNotification:datePicker.date];
}


@end
