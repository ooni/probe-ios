#import "Onboarding3ViewController.h"

@interface Onboarding3ViewController ()

@end

@implementation Onboarding3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;

    [self.titleLabel setText:NSLocalizedString(@"things_to_know", nil)];
    
    NSMutableAttributedString *things_to_know_1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"• %@\n\n• %@\n\n• %@\n\n• %@", NSLocalizedString(@"things_to_know_1", nil), NSLocalizedString(@"things_to_know_2", nil), NSLocalizedString(@"things_to_know_3", nil), NSLocalizedString(@"things_to_know_4", nil)]];
    [things_to_know_1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, things_to_know_1.length)];
    
    [self.textLabel setAttributedText:things_to_know_1];
    [self.nextButton setTitle:NSLocalizedString(@"i_understand", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showQuiz:(id)sender{
    UIViewController *aViewController = [[UIViewController alloc] initWithNibName:@"Quiz" bundle:nil];
    quizView = aViewController.view;
    UIButton *trueButton = (UIButton*)[quizView viewWithTag:1];
    [trueButton addTarget:self action:@selector(answerTrue) forControlEvents:UIControlEventTouchUpInside];
    //[trueButton setTitle:@"" forState:UIControlStateNormal];
    PopupView* popup = [PopupView popupViewWithContentView:quizView];
    //[popup setDidFinishDismissingCompletion:^{}];
    [popup show];
}

-(IBAction)answerTrue{
    LOTAnimationView *animation = [LOTAnimationView animationNamed:@"checkMark"];
    animation.contentMode = UIViewContentModeScaleAspectFit;
    [animation setBackgroundColor:[UIColor colorWithRGBHexString:color_teal4 alpha:1.0f]];

    [quizView addSubview:animation];
    CGRect c = quizView.bounds;
    animation.frame = CGRectMake(0, 0, c.size.width, c.size.height);
    [self.view setNeedsLayout];

    [animation playWithCompletion:^(BOOL animationFinished) {
        [animation removeFromSuperview];
    }];
}

@end
