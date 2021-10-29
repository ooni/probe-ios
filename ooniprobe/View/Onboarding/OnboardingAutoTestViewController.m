#import "OnboardingAutoTestViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsUtility.h"

@interface OnboardingAutoTestViewController ()

@end

@implementation OnboardingAutoTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yesButton.layer.cornerRadius = 30;
    self.yesButton.layer.masksToBounds = true;
    
    self.noButton.layer.cornerRadius = 30;
    self.noButton.layer.masksToBounds = true;
    self.noButton.layer.borderWidth = 3.0f;
    self.noButton.layer.borderColor = [UIColor whiteColor].CGColor;

    [self.yesButton setTitle:NSLocalizedString(@"Modal.SoundsGreat", nil)  forState:UIControlStateNormal];
    [self.noButton setTitle:NSLocalizedString(@"Modal.NotNow", nil)  forState:UIControlStateNormal];

    [self.titleLabel setText:NSLocalizedString(@"Onboarding.AutomatedTesting.Title", nil)];
    
    [self.textLabel setText:NSLocalizedString(@"Onboarding.AutomatedTesting.Paragraph", nil)];
}

-(IBAction)acceptAutoTest{
    [SettingsUtility enableAutorun];
    [self performSegueWithIdentifier:@"toOnboardingCrash" sender:self];
}

-(IBAction)refuseAutoTest{
    [self performSegueWithIdentifier:@"toOnboardingCrash" sender:self];
}

@end
