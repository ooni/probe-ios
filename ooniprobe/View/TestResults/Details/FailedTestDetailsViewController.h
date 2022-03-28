#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"

@interface FailedTestDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *tryAgainButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadBarFooterConstraint;

@end
