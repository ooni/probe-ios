// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import "RoundedButton.h"
#import "Tests.h"

@interface TestInfoViewController : UIViewController {
    Tests *currentTests;
}

@property (nonatomic, strong) IBOutlet NSString *testName;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet RoundedButton *runButton;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@end

