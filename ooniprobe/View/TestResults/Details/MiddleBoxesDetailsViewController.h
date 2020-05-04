#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"
#import "PaddingLabel.h"

/**
 * @deprecated
 * Is not possible to run a MiddleBoxesSuite anymore
 * so the MiddleBoxesDetailsViewController is not gonna be shown for new tests
 */
__deprecated
@interface MiddleBoxesDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;

@end
