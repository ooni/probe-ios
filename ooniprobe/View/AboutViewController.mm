#import "AboutViewController.h"
#import <measurement_kit/common.hpp>
#import "VersionUtility.h"

@interface AboutViewController ()
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"about_ooni", nil);
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    [self.headerView setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    [self.learnMoreButton setTitle:NSLocalizedString(@"learn_more", nil) forState:UIControlStateNormal];
    self.learnMoreButton.layer.cornerRadius = 20;
    self.learnMoreButton.layer.masksToBounds = YES;
    [self.learnMoreButton setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
    [self.learnMoreButton setBackgroundColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]];
    
    [self.textLabel setText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"about_text_1", nil),  NSLocalizedString(@"about_text_2", nil)]];
    [self.textLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    
    [self.ppButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"view_data_policy", nil)] forState:UIControlStateNormal];
    [self.ppButton setTitleColor:[UIColor colorWithRGBHexString:color_blue5 alpha:1.0f]
                        forState:UIControlStateNormal];
    
    [self.versionLabel setText:[NSString stringWithFormat:@"ooniprobe: %@\nmeasurement-kit: %s", [VersionUtility get_software_version], mk_version()]];
    [self.versionLabel setTextColor:[UIColor whiteColor]];
}


-(IBAction)learn_more:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/"]];
}


-(IBAction)privacy_policy:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/about/data-policy/"]];
}


@end
