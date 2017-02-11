// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "AboutViewController.h"

@interface AboutViewController ()
@property (readwrite) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector(revealLeftView)];
    self.revealViewController.leftPresentViewHierarchically = YES;
    self.revealViewController.toggleAnimationType = PBRevealToggleAnimationTypeSpring;
    self.view.backgroundColor = color_off_black;

    [self.titleLabel setText:NSLocalizedString(@"about_ooni", nil)];
    [self.learnMoreButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
    [self.textLabel setText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"about_text_1", nil),  NSLocalizedString(@"about_text_2", nil)]];
    [self.ppButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"view_data_policy", nil)] forState:UIControlStateNormal];

}

-(IBAction)learn_more:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/"]];
}


-(IBAction)privacy_policy:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/about/data-policy/"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
