#import "Onboarding1ViewController.h"

@interface Onboarding1ViewController ()

@end

@implementation Onboarding1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextButton.layer.cornerRadius = 30;
    self.nextButton.layer.masksToBounds = true;
    
    [self.nextButton setTitle:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.GotIt", nil) forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorNamed:@"color_blue8"]
                           forState:UIControlStateNormal];

    [self.titleLabel setText:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Title", nil)];
    [self.textLabel setText:NSLocalizedString(@"Onboarding.WhatIsOONIProbe.Paragraph", nil)];
}


@end
