#import "ProxyViewController.h"
#import "LocalizationUtility.h"

@interface ProxyViewController ()

@end

@implementation ProxyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    currentProxy = [[ProxySettings alloc] init];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self.view action:@selector(endEditing:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    [self reloadRows];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [currentProxy saveProxy];
}

- (void)reloadRows{
    if ([currentProxy isCustom])
        items = @[
        @[[ProxySettings getProtocol:NONE],
          [ProxySettings getProtocol:PSIPHON],
          @"proxy_custom"],
        @[
                [ProxySettings getProtocol:SOCKS5],
                [ProxySettings getProtocol:HTTP],
                [ProxySettings getProtocol:HTTPS]
        ],
        @[@"proxy_hostname", @"proxy_port"]];
    else
        items = @[@[[ProxySettings getProtocol:NONE],
                  [ProxySettings getProtocol:PSIPHON],
                  @"proxy_custom"]];
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
    if (indexPath.section == 0 || indexPath.section == 1){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = [LocalizationUtility getNameForSetting:current];
        cell.textLabel.textColor = [UIColor colorNamed:@"color_gray9"];
        cell.accessoryView = nil;
        //Proxy protocol
        if ([current isEqualToString:[ProxySettings getProtocol:currentProxy.protocol]] ||
            ([current isEqualToString:@"proxy_custom"] && [currentProxy isCustom]))
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellField" forIndexPath:indexPath];
        UITextField *textField = (UITextField*)[cell viewWithTag:1];
        textField.textColor = [UIColor colorNamed:@"color_gray9"];
        textField.inputAccessoryView = keyboardToolbar;
        textField.placeholder = [LocalizationUtility getNameForSetting:current];
        if ([current isEqualToString:@"proxy_port"]){
            textField.text = currentProxy.port;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        else if ([current isEqualToString:@"proxy_hostname"]){
            textField.text = currentProxy.hostname;
            textField.keyboardType = UIKeyboardTypeURL;
            if ([self checkURL:currentProxy.hostname])
                textField.textColor = [UIColor colorNamed:@"color_black"];
            else
                textField.textColor = [UIColor colorNamed:@"color_red8"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 0)
            currentProxy.protocol = NONE;
        else if (indexPath.row == 1)
            currentProxy.protocol = PSIPHON;
        if (indexPath.row == 2)
            [self setCustom:SOCKS5];
        [self reloadRows];
    } else if (indexPath.section == 1){
        if (indexPath.row == 0)
            [self setCustom:SOCKS5];
        else if (indexPath.row == 1)
            [self setCustom:HTTP];
        else if (indexPath.row == 2)
            [self setCustom:HTTPS];
        [self reloadRows];
    }
    //[self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setCustom:(enum ProxyProtocol)protocol {
    currentProxy.protocol = protocol;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *current = [[items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([current isEqualToString:@"proxy_port"]){
        currentProxy.port = str;
    }
    else if ([current isEqualToString:@"proxy_hostname"]){
        currentProxy.hostname = str;
        if ([self checkURL:currentProxy.hostname])
            textField.textColor = [UIColor colorNamed:@"color_black"];
        else
            textField.textColor = [UIColor colorNamed:@"color_red8"];
    }
    return YES;
}

//TODO not ideal function, maybe remove it
-(BOOL)checkURL:(NSString*)urlString{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@",
                                       [ProxySettings getProtocol:currentProxy.protocol],
                                       urlString]];
    if (url && url.scheme && url.host)
        return true;
    return false;
}

@end
