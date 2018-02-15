#import "PopQuizViewController.h"

@interface PopQuizViewController ()

@end

@implementation PopQuizViewController
@synthesize question_number;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.trueButton addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    [self.trueButton setTitle:[NSLocalizedString(@"_true", nil) uppercaseString] forState:UIControlStateNormal];
    
    [self.falseButton addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    [self.falseButton setTitle:[NSLocalizedString(@"_false", nil) uppercaseString] forState:UIControlStateNormal];
    
    [self.trueButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
    [self.trueButton setBackgroundColor:[UIColor colorWithRGBHexString:color_teal5 alpha:1.0f]];
    [self.falseButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
    [self.falseButton setBackgroundColor:[UIColor colorWithRGBHexString:color_red6 alpha:1.0f]];

    [self.closeView addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    
    self.cointainerWindow.layer.cornerRadius = 12;
    self.cointainerWindow.layer.masksToBounds = true;
    [self.cointainerWindow setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    [self.cointainerWindow setBackgroundColor:[UIColor colorWithRed:5.0/255.0 green:136.0/255.0 blue:203.0/255.0 alpha:1.0]];
    
    [self.titleLabel setText:NSLocalizedString(@"pop_quiz", nil)];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setTextColor:[UIColor whiteColor]];

    [self reloadQuestion];
}

- (void)reloadQuestion{
    NSMutableAttributedString *questionIntro = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%@ %ld/2\n\n", NSLocalizedString(@"question", nil), question_number]];
    [questionIntro addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                           range:NSMakeRange(0, questionIntro.length)];
    NSMutableAttributedString *questionText;
    if (question_number == 1)
        questionText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"question_1", nil)];
    else if (question_number == 2)
        questionText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"question_2", nil)];
    else {
        //should not happen
        assert(false);
    }
        
    [questionText addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                          range:NSMakeRange(0, questionText.length)];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:questionIntro];
    [attrStr appendAttributedString:questionText];
    [self.textLabel setAttributedText:attrStr];
}

- (void)nextQuestion {
    if (question_number == 1){
        question_number = 2;
        [self reloadQuestion];
    }
    else if (question_number == 2){
        question_number = 3;
        [self dismissPopup];
    }
}

-(void)dismissPopup{
    [self dismissViewControllerAnimated:YES completion:^{
        //set back question number
        [_delegate setQuestion_number:question_number];
    }];
}

-(IBAction)answer:(id)sender{
    UIButton *buttonPressed = (UIButton*)sender;
    BOOL answer = false;
    if (buttonPressed.tag == 1)
        answer = true;
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
    
    [self.cointainerWindow addSubview:animation];
    CGRect c = self.cointainerWindow.bounds;
    animation.frame = CGRectMake(0, 0, c.size.width, c.size.height);
    [self.view setNeedsLayout];
    
    [animation playWithCompletion:^(BOOL animationFinished) {
        [animation removeFromSuperview];
        if (!answer)
            [self performSegueWithIdentifier:@"toWrongAnswer" sender:self];
        else
            [self nextQuestion];
    }];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toWrongAnswer"]){
        WrongAnswerViewController *vc = (WrongAnswerViewController * )segue.destinationViewController;
        [vc setDelegate:self];
    }
}

@end
