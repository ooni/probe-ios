#import "Onboarding4ViewController.h"

@interface Onboarding4ViewController ()

@end

@implementation Onboarding4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];

    //Constraint for iPhoneSE
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 568)
        {
            self.topConstraint.constant = 8.0f;
            self.bottomConstraint.constant = 0.0f;
        }
    }
    self.buttonView.layer.cornerRadius = 30;
    self.buttonView.layer.masksToBounds = true;

    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"default_settings", nil)];
    
    NSMutableAttributedString *weWillCollect = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"we_will_collect", nil)];
    [weWillCollect addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, weWillCollect.length)];
    
    NSMutableAttributedString *defaultSettings1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_1", nil)]];
    [defaultSettings1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                                range:NSMakeRange(0, defaultSettings1.length)];
    
    NSMutableAttributedString *defaultSettings2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_2", nil)]];
    [defaultSettings2 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, defaultSettings2.length)];

    NSMutableAttributedString *defaultSettings3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_3", nil)]];
    [defaultSettings3 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, defaultSettings3.length)];

    NSMutableAttributedString *weWillNotCollect = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n%@", NSLocalizedString(@"we_will_not_collect", nil)]];
    [weWillNotCollect addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, weWillNotCollect.length)];

    NSMutableAttributedString *defaultSettings4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"default_settings_4", nil)]];
    [defaultSettings4 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, defaultSettings4.length)];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:weWillCollect];
    [attrStr appendAttributedString:defaultSettings1];
    [attrStr appendAttributedString:defaultSettings2];
    [attrStr appendAttributedString:defaultSettings3];
    [attrStr appendAttributedString:weWillNotCollect];
    [attrStr appendAttributedString:defaultSettings4];

    [self.textLabel setAttributedText:attrStr];
    [self.textLabel setTextColor:[UIColor whiteColor]];

    [self.changeButton setTitle:[NSLocalizedString(@"change", nil) uppercaseString] forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [self.changeButton setBackgroundColor:[UIColor colorWithRGBHexString:color_blue8 alpha:1.0f]];

    [self.goButton setTitle:[NSLocalizedString(@"lets_go", nil) uppercaseString] forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor colorWithRGBHexString:color_blue8 alpha:1.0f]
                          forState:UIControlStateNormal];
    [self.goButton setBackgroundColor:[UIColor whiteColor]];
}

-(IBAction)configure:(id)sender{
    UIButton *buttonPressed = (UIButton*)sender;
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"first_run"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        if (buttonPressed == _changeButton){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openSettings" object:nil];
        }
    }];
}

@end
