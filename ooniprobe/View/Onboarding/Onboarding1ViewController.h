#import <UIKit/UIKit.h>

@interface Onboarding1ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end
