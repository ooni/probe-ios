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

    [self.titleLabel setText:NSLocalizedString(@"Onboarding.ThingsToKnow.Title", nil)];
    
    NSString *thingsToKnow = [NSString stringWithFormat:@"• %@\n• %@\n• %@", NSLocalizedString(@"Onboarding.ThingsToKnow.Bullet.1", nil), NSLocalizedString(@"Onboarding.ThingsToKnow.Bullet.2", nil), NSLocalizedString(@"Onboarding.ThingsToKnow.Bullet.3", nil)];
    
    [self.textLabel setText:thingsToKnow];
    [self.nextButton setTitle:NSLocalizedString(@"Onboarding.ThingsToKnow.Button", nil) forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorNamed:@"color_blue8"]
                               forState:UIControlStateNormal];
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
