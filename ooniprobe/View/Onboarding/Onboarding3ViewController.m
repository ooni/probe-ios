#import "Onboarding3ViewController.h"

@interface Onboarding3ViewController ()

@end

@implementation Onboarding3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.goButton.layer.cornerRadius = 30;
    self.goButton.layer.masksToBounds = true;

    [self.titleLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.titleLabel setText:NSLocalizedString(@"Onboarding.DefaultSettings.Title", nil)];

    NSString *defaultSettings = [NSString stringWithFormat:@"**%@**\n• %@\n• %@\n• %@\n%@", NSLocalizedString(@"Onboarding.DefaultSettings.Header", nil), NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.1", nil), NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.2", nil),
        NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.3", nil),
        NSLocalizedString(@"Onboarding.DefaultSettings.Paragraph", nil)];
    [self.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:17]];
    [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    NSMutableDictionary* linkAttrs = [NSMutableDictionary dictionaryWithDictionary:self.textLabel.linkAttributes];
    [linkAttrs setObject:(__bridge id)[UIColor colorWithRGBHexString:color_white alpha:1.0f].CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    [linkAttrs setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCTUnderlineStyleAttributeName];
    self.textLabel.linkAttributes = linkAttrs;
    [self.textLabel setMarkdown:defaultSettings];
    [self.textLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];
    [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];

    [self.changeButton setTitle:NSLocalizedString(@"Onboarding.DefaultSettings.Button.Change", nil)  forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]
                          forState:UIControlStateNormal];

    [self.goButton setTitle:NSLocalizedString(@"Onboarding.DefaultSettings.Button.Go", nil) forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor colorWithRGBHexString:color_blue8 alpha:1.0f]
                          forState:UIControlStateNormal];
    [self.goButton setBackgroundColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
}

-(void)acceptDefaultSettings{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"send_analytics"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"send_crash"];
}

-(IBAction)configure:(id)sender{
    UIButton *buttonPressed = (UIButton*)sender;
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:ONBOARDING_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:ANALYTICS_POPUP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^{
        if (buttonPressed == _changeButton){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openSettings" object:nil];
        }
        else {
            [self acceptDefaultSettings];
        }
    }];
}

@end
