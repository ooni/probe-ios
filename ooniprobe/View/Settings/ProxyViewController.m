#import "ProxyViewController.h"
#import "LocalizationUtility.h"

@interface ProxyViewController ()

@end

@implementation ProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    [self reloadRows];
}

- (void)reloadRows{
    NSString *proxy_value = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_enabled"];
    if ([proxy_value isEqualToString:@"proxy_custom"])
        items = @[
        @[@"proxy_none", @"proxy_psiphon", @"proxy_custom"],
        @[@"HTTP", @"SOCKS5"],
        @[@"proxy_custom_hostname", @"proxy_custom_port"],
        @[@"proxy_custom_username", @"proxy_custom_password"],
        @[@"proxy_psiphon_over_custom"]];
    else
        items = @[@[@"proxy_none", @"proxy_psiphon", @"proxy_custom"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[items objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"Settings.Proxy.Enabled", nil);
    else if (section == 1)
        return NSLocalizedString(@"Settings.Proxy.Custom.Protocol", nil);
    else if (section == 2)
        return NSLocalizedString(@"Settings.Proxy.Custom.Connection", nil);
    else if (section == 3)
        return NSLocalizedString(@"Settings.Proxy.Custom.Credentials", nil);
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return NSLocalizedString(@"Settings.Proxy.Footer", nil);
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 4)
        return CGFLOAT_MIN;
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *current = [[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 2 || indexPath.section == 3){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellField" forIndexPath:indexPath];
        UITextField *textField = (UITextField*)[cell viewWithTag:1];
        textField.textColor = [UIColor colorNamed:@"color_gray9"];
        textField.inputAccessoryView = keyboardToolbar;
        textField.placeholder = [LocalizationUtility getNameForSetting:current];
        
        if ([current isEqualToString:@"proxy_custom_port"]){
            NSInteger value = [[NSUserDefaults standardUserDefaults] integerForKey:current];
            if (value != 0)
                textField.text = [NSString stringWithFormat:@"%ld", (long)value];
        }
        else {
            NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:current];
            textField.text = value;
        }

        if ([current isEqualToString:@"proxy_custom_port"])
            textField.keyboardType = UIKeyboardTypeNumberPad;
        else if ([current isEqualToString:@"proxy_custom_hostname"])
            textField.keyboardType = UIKeyboardTypeURL;
        else
            textField.keyboardType = UIKeyboardTypeDefault;
        
        if ([current isEqualToString:@"proxy_custom_password"])
            textField.secureTextEntry = true;
        else
            textField.keyboardType = false;
    }
    else if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [LocalizationUtility getNameForSetting:current];
        cell.textLabel.textColor = [UIColor colorNamed:@"color_gray9"];
        cell.accessoryView = nil;
        if ([current isEqualToString:@"proxy_none"] ||
            [current isEqualToString:@"proxy_psiphon"] ||
            [current isEqualToString:@"proxy_custom"]){
            NSString *proxy_value = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_enabled"];
            if ([proxy_value isEqualToString:current])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if ([current isEqualToString:@"HTTP"] || [current isEqualToString:@"SOCKS5"]){
            NSString *protocol_value = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_custom_protocol"];
            if ([protocol_value isEqualToString:current])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else {
            BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:current];
            if (value)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else
                cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *current = [[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4){
        if ([current isEqualToString:@"proxy_none"] ||
            [current isEqualToString:@"proxy_psiphon"] ||
            [current isEqualToString:@"proxy_custom"]){
            [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"proxy_enabled"];
        }
        else if ([current isEqualToString:@"HTTP"] || [current isEqualToString:@"SOCKS5"]){
            [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"proxy_custom_protocol"];
        }
        else {
            BOOL value = [[NSUserDefaults standardUserDefaults] boolForKey:current];
            [[NSUserDefaults standardUserDefaults] setBool:!value forKey:current];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self reloadRows];
    }
    //[self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *current = [[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([current isEqualToString:@"proxy_custom_port"]){
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterNoStyle;
        [[NSUserDefaults standardUserDefaults] setObject:[f numberFromString:str] forKey:current];
    }
    else
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:current];
    return YES;
}


@end
