// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "SettingsTableViewController.h"
#define settings 4
#define notification 1

@interface SettingsTableViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];

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
        return [settingsItems count];
    else if (section == 1) return [otherItems count];
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"collector_settings", nil);
    else if (section == 1)
        return NSLocalizedString(@"notifications", nil);
    return NSLocalizedString(@"test_limits", nil);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0){
        if (indexPath.row < settings){
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
            NSString *current = [settingsItems objectAtIndex:indexPath.row];
            cell.textLabel.text = NSLocalizedString(current, nil);
            cell.imageView.image = [UIImage imageNamed:current];
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchview addTarget:self action:@selector(setSwitch:) forControlEvents:UIControlEventValueChanged];
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:current] boolValue]) switchview.on = YES;
            else switchview.on = NO;
            cell.accessoryView = switchview;
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellSub" forIndexPath:indexPath];
            NSString *current = [settingsItems objectAtIndex:indexPath.row];
            cell.textLabel.text = NSLocalizedString(current, nil);
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:current];
        }
    }
    else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSString *current = [otherItems objectAtIndex:indexPath.row];
        cell.textLabel.text = NSLocalizedString(current, nil);
        cell.imageView.image = [UIImage imageNamed:current];
        if (indexPath.row < notification){
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
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSNumber *time = [[NSUserDefaults standardUserDefaults] objectForKey:@"max_runtime"];
        cell.textLabel.text = NSLocalizedString(@"max_runtime", nil);
        cell.imageView.image = [UIImage imageNamed:@"max_runtime"];
        UITextField *textField = [self createTextField:[NSString stringWithFormat:@"%@", time]];
        cell.accessoryView = textField;
    }
    return cell;
}

- (UITextField*)createTextField:(NSString*)text{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    textField.delegate = self;
    textField.font = [UIFont fontWithName:@"FiraSans-Bold" size:15.0f];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.text = text;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    return textField;
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
        current = [settingsItems objectAtIndex:indexpath.row];
    else
        current = [otherItems objectAtIndex:indexpath.row];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAvailableMeasurements" object:nil];
}

-(void)reloadSettings {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"upload_results"] boolValue])
        settingsItems = @[@"include_ip", @"include_asn", @"include_cc", @"upload_results", @"collector_address"];
    else
        settingsItems = @[@"include_ip", @"include_asn", @"include_cc", @"upload_results"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"local_notifications"] boolValue])
        otherItems = @[@"local_notifications", @"local_notifications_time"];
    else
        otherItems = @[@"local_notifications"];
    [self.tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == [settingsItems count] -1){
        NSString *current = [settingsItems objectAtIndex:indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(current, @"") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", nil), nil];
        alert.tag = indexPath.row;
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
    if (buttonIndex == 1 && value.text.length > 0) {
        NSString *current = [settingsItems objectAtIndex:alertView.tag];
        [[NSUserDefaults standardUserDefaults] setObject:value.text forKey:current];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadAvailableMeasurements" object:nil];
        [self.tableView reloadData];
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
