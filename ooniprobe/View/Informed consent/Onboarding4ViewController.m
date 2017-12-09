#import "Onboarding4ViewController.h"

@interface Onboarding4ViewController ()

@end

@implementation Onboarding4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonView.layer.cornerRadius = 30;
    self.buttonView.layer.masksToBounds = true;

    [self.titleLabel setText:NSLocalizedString(@"default_settings", nil)];
    
    NSMutableAttributedString *we_will_collect = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"we_will_collect", nil)];
    [we_will_collect addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, we_will_collect.length)];
    
    NSMutableAttributedString *default_settings_1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_1", nil)]];
    [default_settings_1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                                range:NSMakeRange(0, default_settings_1.length)];
    
    NSMutableAttributedString *default_settings_2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_2", nil)]];
    [default_settings_2 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, default_settings_2.length)];

    NSMutableAttributedString *default_settings_3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_3", nil)]];
    [default_settings_3 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, default_settings_3.length)];

    NSMutableAttributedString *we_will_not_collect = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@", NSLocalizedString(@"we_will_not_collect", nil)]];
    [we_will_not_collect addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, we_will_not_collect.length)];

    NSMutableAttributedString *default_settings_4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_4", nil)]];
    [default_settings_4 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, default_settings_4.length)];

    NSMutableAttributedString *attr_str = [[NSMutableAttributedString alloc] init];
    [attr_str appendAttributedString:we_will_collect];
    [attr_str appendAttributedString:default_settings_1];
    [attr_str appendAttributedString:default_settings_2];
    [attr_str appendAttributedString:default_settings_3];
    [attr_str appendAttributedString:we_will_not_collect];
    [attr_str appendAttributedString:default_settings_4];

    [self.textLabel setAttributedText:attr_str];
    [self.backButton setTitle:[NSLocalizedString(@"change", nil) uppercaseString] forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSLocalizedString(@"lets_go", nil) uppercaseString] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)configure:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"first_run"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //[delegate registerNotifications];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"showToastConfiguration" object:nil];
    }];
}

@end
