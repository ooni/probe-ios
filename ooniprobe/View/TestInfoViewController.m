// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "TestInfoViewController.h"

@interface TestInfoViewController ()

@end

@implementation TestInfoViewController
@synthesize testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(testName, nil);

    [self.imageView setImage:[UIImage imageNamed:testName]];
    [self.nextButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
    NSString *test_desc = [NSString stringWithFormat:@"%@_longdesc", testName];
    [self.textLabel setText:NSLocalizedString(test_desc, nil)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)learn_more:(id)sender{
    if ([testName isEqualToString:@"web_connectivity"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/nettest/web-connectivity/"]];
    else if ([testName isEqualToString:@"http_invalid_request_line"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/nettest/http-invalid-request-line/"]];
    else if ([testName isEqualToString:@"ndt_test"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/TheTorProject/ooni-web/blob/master/content/nettest/ndt.md"]];

}

@end
