#import "OnboardingCrashViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface OnboardingCrashViewController ()

@end

@implementation OnboardingCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yesButton.layer.cornerRadius = 30;
    self.yesButton.layer.masksToBounds = true;
    
    self.noButton.layer.cornerRadius = 30;
    self.noButton.layer.masksToBounds = true;
    self.noButton.layer.borderWidth = 3.0f;
    self.noButton.layer.borderColor = [UIColor whiteColor].CGColor;

    [self.yesButton setTitle:NSLocalizedString(@"Onboarding.Crash.Button.Yes", nil)  forState:UIControlStateNormal];
    [self.noButton setTitle:NSLocalizedString(@"Onboarding.Crash.Button.No", nil)  forState:UIControlStateNormal];

    [self.titleLabel setText:NSLocalizedString(@"Onboarding.Crash.Title", nil)];
    
    [self.textLabel setText:NSLocalizedString(@"Onboarding.Crash.Paragraph", nil)];
}

-(IBAction)acceptCrash{
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"send_crash"];
    [self performSegueWithIdentifier:@"toOnboarding3" sender:self];
}

-(IBAction)refuseCrash{
    [self performSegueWithIdentifier:@"toOnboarding3" sender:self];
}

@end
