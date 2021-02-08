#import "WrongAnswerViewController.h"

@interface WrongAnswerViewController ()

@end

@implementation WrongAnswerViewController
@synthesize question_number;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.goBackButton addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackButton setTitle:NSLocalizedString(@"Onboarding.PopQuiz.Wrong.Button.Back", nil)  forState:UIControlStateNormal];

    [self.continueButton addTarget:self action:@selector(nextAndDismissPopupWrongAnswer) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton setTitle:NSLocalizedString(@"Onboarding.PopQuiz.Wrong.Button.Continue", nil) forState:UIControlStateNormal];

    [self.goBackButton setBackgroundColor:[UIColor colorNamed:@"color_gray8"]];
    [self.continueButton setTitleColor:[UIColor colorNamed:@"color_gray8"]
                           forState:UIControlStateNormal];

    [self.closeView addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];

    [self.cointainerWindow setBackgroundColor:[UIColor colorNamed:@"color_gray8"]];
    self.cointainerWindow.layer.cornerRadius = 12;
    self.cointainerWindow.layer.masksToBounds = true;
    if (question_number == 1){
        [self.titleLabel setText:NSLocalizedString(@"Onboarding.PopQuiz.1.Wrong.Title", nil)];
        [self.textLabel setText:NSLocalizedString(@"Onboarding.PopQuiz.1.Wrong.Paragraph", nil)];
    }
    else {
        [self.titleLabel setText:NSLocalizedString(@"Onboarding.PopQuiz.2.Wrong.Title", nil)];
        [self.textLabel setText:NSLocalizedString(@"Onboarding.PopQuiz.2.Wrong.Paragraph", nil)];
    }
}

-(void)nextAndDismissPopupWrongAnswer{
    [self dismissViewControllerAnimated:YES completion:^{
        [_delegate nextQuestion];
    }];
}

-(void)dismissAllPopups{
    [self dismissViewControllerAnimated:NO completion:^{}];
    [_delegate dismissPopup];
}

@end
