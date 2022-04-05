#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"
#import "PaddingLabel.h"

//This screen is still used for HIRL and HHFM under the Performance suite
@interface MiddleBoxesDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadBarFooterConstraint;

@end
