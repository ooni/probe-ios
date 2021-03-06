#import "Onboarding3ViewController.h"
#import "CountlyUtility.h"

@interface Onboarding3ViewController ()

@end

@implementation Onboarding3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.goButton.layer.cornerRadius = 30;
    self.goButton.layer.masksToBounds = true;

    [self.titleLabel setTextColor:[UIColor colorNamed:@"color_white"]];
    [self.titleLabel setText:NSLocalizedString(@"Onboarding.DefaultSettings.Title", nil)];

    NSString *defaultSettings = [NSString stringWithFormat:@"**%@**\n• %@\n• %@\n• %@\n%@", NSLocalizedString(@"Onboarding.DefaultSettings.Header", nil), NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.1", nil), NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.2", nil),
        NSLocalizedString(@"Onboarding.DefaultSettings.Bullet.3", nil),
        NSLocalizedString(@"Onboarding.DefaultSettings.Paragraph", nil)];
    [self.textLabel setFont:[UIFont fontWithName:@"FiraSans-Regular" size:17]];
    NSMutableDictionary* linkAttrs = [NSMutableDictionary dictionaryWithDictionary:self.textLabel.linkAttributes];
    [linkAttrs setObject:[NSNumber numberWithBool:YES] forKey:(NSString*)kCTUnderlineStyleAttributeName];
    self.textLabel.linkAttributes = linkAttrs;
    [self.textLabel setMarkdown:defaultSettings];
    [self.textLabel setDidSelectLinkWithURLBlock:^(RHMarkdownLabel *label, NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];

    [self.changeButton setTitle:NSLocalizedString(@"Onboarding.DefaultSettings.Button.Change", nil)  forState:UIControlStateNormal];

    [self.goButton setTitle:NSLocalizedString(@"Onboarding.DefaultSettings.Button.Go", nil) forState:UIControlStateNormal];
    [self.goButton setTitleColor:[UIColor colorNamed:@"color_blue8"]
                          forState:UIControlStateNormal];
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
            [CountlyUtility reloadConsents];
        }
    }];
}

@end
