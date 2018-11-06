#import "Onboarding2ViewController.h"

@interface Onboarding2ViewController ()

@end

@implementation Onboarding2ViewController
@synthesize question_number;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;
    question_number = 1;
    [self.learnMoreButton setTitle:NSLocalizedString(@"Onboarding.ThingsToKnow.LearnMore", nil) forState:UIControlStateNormal];
    [self.learnMoreButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];

    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"Onboarding.ThingsToKnow.Title", nil)];
    
    NSMutableAttributedString *thingsToKnow1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"• %@\n• %@\n• %@", NSLocalizedString(@"Onboarding.ThingsToKnow.Bullet.1", nil), NSLocalizedString(@"Onboarding.ThingsToKnow.Bullet.2", nil), NSLocalizedString(@"Onboarding.ThingsToKnow.Bullet.3", nil)]];
    [thingsToKnow1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, thingsToKnow1.length)];
    
    [self.textLabel setAttributedText:thingsToKnow1];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.nextButton setTitle:NSLocalizedString(@"Onboarding.ThingsToKnow.Button", nil) forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorWithRGBHexString:color_blue8 alpha:1.0f]
                               forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor whiteColor]];

}

-(void)setQuestion_number:(int)qn
{
    question_number = qn;
    if (qn == 3){
        [self performSegueWithIdentifier:@"toOnboarding3" sender:self];
    }
}

-(IBAction)learnMore:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.io/about/risks/"]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toPopQuiz"]){
        PopQuizViewController *vc = (PopQuizViewController * )segue.destinationViewController;
        [vc setQuestion_number:question_number];
        [vc setDelegate:self];
    }
}

@end
