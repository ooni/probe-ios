#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <PopupKit/PopupView.h>
#import <Lottie/Lottie.h>

@interface Onboarding3ViewController : UIViewController {
    UIView *quizView;
}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end
