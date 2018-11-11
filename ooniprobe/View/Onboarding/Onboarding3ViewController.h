#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RHMarkdownLabel.h"
@interface Onboarding3ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet RHMarkdownLabel *textLabel;

@property (strong, nonatomic) IBOutlet UIButton *changeButton;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
