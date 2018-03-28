#import "Onboarding3ViewController.h"

@interface Onboarding3ViewController ()

@end

@implementation Onboarding3ViewController
@synthesize question_number;

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
    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;
    question_number = 1;
    
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setText:NSLocalizedString(@"things_to_know", nil)];
    
    NSMutableAttributedString *thingsToKnow1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"• %@\n\n• %@\n\n• %@\n\n• %@", NSLocalizedString(@"things_to_know_1", nil), NSLocalizedString(@"things_to_know_2", nil), NSLocalizedString(@"things_to_know_3", nil), NSLocalizedString(@"things_to_know_4", nil)]];
    [thingsToKnow1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, thingsToKnow1.length)];
    
    [self.textLabel setAttributedText:thingsToKnow1];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.nextButton setTitle:[NSLocalizedString(@"i_understand", nil) uppercaseString] forState:UIControlStateNormal];
    
    [self.nextButton setTitleColor:[UIColor colorWithRGBHexString:color_blue8 alpha:1.0f]
                               forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor whiteColor]];

}

-(void)setQuestion_number:(int)qn
{
    question_number = qn;
    if (qn == 3){
        [self.nextButton setHidden:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextPage" object:nil];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toPopQuiz"]){
        PopQuizViewController *vc = (PopQuizViewController * )segue.destinationViewController;
        [vc setQuestion_number:question_number];
        [vc setDelegate:self];
    }
}

@end
