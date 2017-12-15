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
    
    [self.closeView addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    
    self.cointainerWindow.layer.cornerRadius = 12;
    self.cointainerWindow.layer.masksToBounds = true;
    
    [self.titleLabel setText:NSLocalizedString(@"pop_quiz", nil)];
    [self reloadQuestion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadQuestion{
    NSMutableAttributedString *question_intro = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%@ %ld/2\n\n", NSLocalizedString(@"question", nil), question_number]];
    [question_intro addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                           range:NSMakeRange(0, question_intro.length)];
    NSMutableAttributedString *question_text;
    if (question_number == 1)
        question_text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"question_1", nil)];
    else if (question_number == 2)
        question_text = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"question_2", nil)];
    else {
        //should not happen
        assert(false);
    }
        
    [question_text addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                          range:NSMakeRange(0, question_text.length)];
    
    NSMutableAttributedString *attr_str = [[NSMutableAttributedString alloc] init];
    [attr_str appendAttributedString:question_intro];
    [attr_str appendAttributedString:question_text];
    [self.textLabel setAttributedText:attr_str];
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
