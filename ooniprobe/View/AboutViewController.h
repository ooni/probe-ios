// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import "PBRevealViewController.h"
#import "RoundedButton.h"

@interface AboutViewController : UIViewController
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet RoundedButton *learnMoreButton;
@property (nonatomic, strong) IBOutlet UIButton *ppButton;

@end
