#import "Onboarding1ViewController.h"

@interface Onboarding1ViewController ()

@end

@implementation Onboarding1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:NSLocalizedString(@"welcome_to", nil)];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_base alpha:1.0f]];
}

@end
