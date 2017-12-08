#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <PopupKit/PopupView.h>
#import <Lottie/Lottie.h>
#import "UIColor+TFT.h"

@interface Onboarding3ViewController : UIViewController {
    UIView *quizView;
    UIView *wrongAnswerView;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end
