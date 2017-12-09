#import "Onboarding3ViewController.h"

@interface Onboarding3ViewController ()

@end

@implementation Onboarding3ViewController
@synthesize question_number;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;
    question_number = 1;
    [self.titleLabel setText:NSLocalizedString(@"things_to_know", nil)];
    
    NSMutableAttributedString *things_to_know_1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"• %@\n\n• %@\n\n• %@\n\n• %@", NSLocalizedString(@"things_to_know_1", nil), NSLocalizedString(@"things_to_know_2", nil), NSLocalizedString(@"things_to_know_3", nil), NSLocalizedString(@"things_to_know_4", nil)]];
    [things_to_know_1 addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, things_to_know_1.length)];
    
    [self.textLabel setAttributedText:things_to_know_1];
    [self.nextButton setTitle:[NSLocalizedString(@"i_understand", nil) uppercaseString] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showQuiz:(id)sender{
    UIViewController *aViewController = [[UIViewController alloc] initWithNibName:@"Quiz" bundle:nil];
    quizView = aViewController.view;
    UIButton *trueButton = (UIButton*)[quizView viewWithTag:1];
    [trueButton addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    [trueButton setTitle:[NSLocalizedString(@"_true", nil) uppercaseString] forState:UIControlStateNormal];

    UIButton *falseButton = (UIButton*)[quizView viewWithTag:2];
    [falseButton addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    [falseButton setTitle:[NSLocalizedString(@"_false", nil) uppercaseString] forState:UIControlStateNormal];

    UIButton *closeView = (UIButton*)[quizView viewWithTag:4];
    [closeView addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];

    UIView *cointainerWindow = (UIView*)[quizView viewWithTag:3];
    cointainerWindow.layer.cornerRadius = 12;
    cointainerWindow.layer.masksToBounds = true;
    
    UILabel *title = (UILabel*)[quizView viewWithTag:5];
    [title setText:NSLocalizedString(@"pop_quiz", nil)];
    [self reloadQuestion];
    
    PopupView* popup = [PopupView popupViewWithContentView:quizView];
    [popup setDidFinishDismissingCompletion:^{}];
    [popup show];
}

- (void)reloadQuestion{
    NSMutableAttributedString *question_intro = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld/2\n\n", NSLocalizedString(@"question", nil), question_number]];
    [question_intro addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                                range:NSMakeRange(0, question_intro.length)];
    NSMutableAttributedString *question_text;
    if (question_number == 1)
        question_text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"question_1", nil)];
    else if (question_number == 2)
        question_text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"question_2", nil)];
    UILabel *text = (UILabel*)[quizView viewWithTag:6];
    [question_text addAttribute:NSFontAttributeName
                                value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                                range:NSMakeRange(0, question_text.length)];
    
    NSMutableAttributedString *attr_str = [[NSMutableAttributedString alloc] init];
    [attr_str appendAttributedString:question_intro];
    [attr_str appendAttributedString:question_text];
    [text setAttributedText:attr_str];
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

-(void)nextAndDismissPopupWrongAnswer{
    [self nextQuestion];
    [self dismissPopupWrongAnswer];
}

-(void)dismissAllPopups {
    [self dismissPopup];
    [self dismissPopupWrongAnswer];
}

- (void)nextQuestion {
    if (question_number == 1){
        question_number = 2;
        [self reloadQuestion];
    }
    else if (question_number == 2){
        question_number = 3;
        [self.nextButton setHidden:YES];
        [self dismissPopup];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextPage" object:nil];
    }
}

-(IBAction)answer:(id)sender{
    UIButton *buttonPressed = (UIButton*)sender;
    BOOL answer = false;
    if (buttonPressed.tag == 1)
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
            wrongAnswerView = aViewController.view;
            UIButton *goBackButton = (UIButton*)[wrongAnswerView viewWithTag:1];
            [goBackButton addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];
            [goBackButton setTitle:[NSLocalizedString(@"go_back", nil) uppercaseString] forState:UIControlStateNormal];
            UIButton *continueButton = (UIButton*)[wrongAnswerView viewWithTag:2];
            [continueButton addTarget:self action:@selector(nextAndDismissPopupWrongAnswer) forControlEvents:UIControlEventTouchUpInside];
            [continueButton setTitle:[NSLocalizedString(@"_continue", nil) uppercaseString] forState:UIControlStateNormal];
            UIButton *closeView = (UIButton*)[aViewController.view viewWithTag:4];
            [closeView addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];
            UIView *cointainerWindow = (UIView*)[wrongAnswerView viewWithTag:3];
            cointainerWindow.layer.cornerRadius = 12;
            cointainerWindow.layer.masksToBounds = true;
            PopupView* popup = [PopupView popupViewWithContentView:wrongAnswerView];
            [popup setDidFinishDismissingCompletion:^{
                [closeView setHidden:YES];
            }];
            [popup show];
        }
        else
            [self nextQuestion];
    }];
}


@end
