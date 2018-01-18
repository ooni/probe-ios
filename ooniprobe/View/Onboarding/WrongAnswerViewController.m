#import "WrongAnswerViewController.h"

@interface WrongAnswerViewController ()

@end

@implementation WrongAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.goBackButton addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackButton setTitle:[NSLocalizedString(@"go_back", nil) uppercaseString] forState:UIControlStateNormal];

    [self.continueButton addTarget:self action:@selector(nextAndDismissPopupWrongAnswer) forControlEvents:UIControlEventTouchUpInside];
    [self.continueButton setTitle:[NSLocalizedString(@"_continue", nil) uppercaseString] forState:UIControlStateNormal];

    [self.closeView addTarget:self action:@selector(dismissAllPopups) forControlEvents:UIControlEventTouchUpInside];

    self.cointainerWindow.layer.cornerRadius = 12;
    self.cointainerWindow.layer.masksToBounds = true;
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
