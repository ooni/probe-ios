#import "Onboarding1ViewController.h"

@interface Onboarding1ViewController ()

@end

@implementation Onboarding1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:NSLocalizedString(@"welcome_to", nil)];
}

@end
