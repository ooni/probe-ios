#import "Onboarding3ViewController.h"

@interface Onboarding3ViewController ()

@end

@implementation Onboarding3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.goButton.layer.cornerRadius = 30;
    self.goButton.layer.masksToBounds = true;

    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"Onboarding.DefaultSettings.Title", nil)];

    NSMutableAttributedString *weWillCollect = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Onboarding.DefaultSettings.Header.1", nil)];
    [weWillCollect addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, weWillCollect.length)];
    
    NSMutableAttributedString *defaultSettings1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n• %@", NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.1", nil)]];
    [defaultSettings1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                                range:NSMakeRange(0, defaultSettings1.length)];
    
    NSMutableAttributedString *defaultSettings2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n• %@", NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.2", nil)]];
    [defaultSettings2 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, defaultSettings2.length)];

    NSMutableAttributedString *defaultSettings3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n• %@", NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.3", nil)]];
    [defaultSettings3 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, defaultSettings3.length)];

    NSMutableAttributedString *defaultSettings4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n• %@", NSLocalizedString(@"Onboarding.DefaultSettings.Paragraph", nil)]];
    [defaultSettings4 addAttribute:NSFontAttributeName
                               value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                               range:NSMakeRange(0, defaultSettings4.length)];

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:weWillCollect];
    [attrStr appendAttributedString:defaultSettings1];
    [attrStr appendAttributedString:defaultSettings2];
    [attrStr appendAttributedString:defaultSettings3];
    [attrStr appendAttributedString:defaultSettings4];

    [self.textLabel setAttributedText:attrStr];
    [self.textLabel setTextColor:[UIColor whiteColor]];

    [self.changeButton setTitle:NSLocalizedString(@"Onboarding.DefaultSettings.Button.Change", nil)  forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];

    [self.goButton setTitle:NSLocalizedString(@"Onboarding.DefaultSettings.Button.Go", nil) forState:UIControlStateNormal];
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
