#import <UIKit/UIKit.h>

@interface OnboardingAutoTestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;

@end
