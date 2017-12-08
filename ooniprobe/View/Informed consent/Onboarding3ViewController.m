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
    UIButton *falseButton = (UIButton*)[quizView viewWithTag:1];
    [falseButton addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *trueButton = (UIButton*)[quizView viewWithTag:2];
    [trueButton addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *closeView = (UIButton*)[quizView viewWithTag:4];
    [closeView addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];

    UIView *cointainerWindow = (UIView*)[quizView viewWithTag:3];
    cointainerWindow.layer.cornerRadius = 12;
    cointainerWindow.layer.masksToBounds = true;

    //[trueButton setTitle:@"" forState:UIControlStateNormal];
    PopupView* popup = [PopupView popupViewWithContentView:quizView];
    [popup setDidFinishDismissingCompletion:^{}];
    [popup show];
}

-(void)dismissPopup{
    UIButton *closeView = (UIButton*)[quizView viewWithTag:4];
    [closeView setHidden:YES];
    [quizView dismissPresentingPopup];
}

-(void)dismissPopupWrongAnswer{
    UIButton *closeView = (UIButton*)[wrongAnswerView viewWithTag:4];
    [closeView setHidden:YES];
    [wrongAnswerView dismissPresentingPopup];
}

-(IBAction)answer:(id)sender{
    UIButton *buttonPressed = (UIButton*)sender;
    BOOL answer = false; 
    if (buttonPressed.tag == 2)
        answer = true;
    UIView *cointainerWindow = (UIView*)[quizView viewWithTag:3];
    LOTAnimationView *animation;
    if (!answer){
        animation = [LOTAnimationView animationNamed:@"crossMark"];
        [animation setBackgroundColor:[UIColor colorWithRGBHexString:color_red6 alpha:1.0f]];
    }
    else {
        animation = [LOTAnimationView animationNamed:@"checkMark"];
        [animation setBackgroundColor:[UIColor colorWithRGBHexString:color_teal4 alpha:1.0f]];
    }
    animation.contentMode = UIViewContentModeScaleAspectFit;

    [cointainerWindow addSubview:animation];
    CGRect c = cointainerWindow.bounds;
    animation.frame = CGRectMake(0, 0, c.size.width, c.size.height);
    [self.view setNeedsLayout];

    [animation playWithCompletion:^(BOOL animationFinished) {
        [animation removeFromSuperview];
        if (!answer){
            UIViewController *aViewController = [[UIViewController alloc] initWithNibName:@"WrongAnswer" bundle:nil];
            UIButton *closeView = (UIButton*)[aViewController.view viewWithTag:4];
            [closeView addTarget:self action:@selector(dismissPopupWrongAnswer) forControlEvents:UIControlEventTouchUpInside];
            wrongAnswerView = aViewController.view;
            UIView *cointainerWindow = (UIView*)[wrongAnswerView viewWithTag:3];
            cointainerWindow.layer.cornerRadius = 12;
            cointainerWindow.layer.masksToBounds = true;
            PopupView* popup = [PopupView popupViewWithContentView:wrongAnswerView];
            [popup setDidFinishDismissingCompletion:^{
                [closeView setHidden:YES];
            }];
            [popup show];
        }
    }];
}


@end
