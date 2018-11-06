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

    [self.goBackButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [self.goBackButton setBackgroundColor:[UIColor colorWithRGBHexString:color_gray8 alpha:1.0f]];
    [self.continueButton setTitleColor:[UIColor colorWithRGBHexString:color_gray8 alpha:1.0f]
                           forState:UIControlStateNormal];
    [self.continueButton setBackgroundColor:[UIColor whiteColor]];

    [self.closeView addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];

    [self.cointainerWindow setBackgroundColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
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
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setTextColor:[UIColor whiteColor]];
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
