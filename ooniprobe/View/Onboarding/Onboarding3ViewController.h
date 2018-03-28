#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PopQuizViewController.h"

@interface Onboarding3ViewController : UIViewController <PopQuizViewControllerDelegate> {
    UIView *quizView;
    UIView *wrongAnswerView;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic, assign) int question_number;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

-(void)setQuestion_number:(int)qn;

@end
