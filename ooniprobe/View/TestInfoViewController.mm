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
    
    [self.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_big", testName]]];
    [self.moreButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"learn_more", nil)] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTest) name:@"reloadTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast:) name:@"showToastFinished" object:nil];
    NSString *test_desc = [NSString stringWithFormat:@"%@_longdesc", testName];
    [self.textLabel setText:NSLocalizedString(test_desc, nil)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    currentTests = [Tests currentTests];
    [self reloadTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showToast:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *test_name = [userInfo objectForKey:@"test_name"];
    [self.view makeToast:[NSString stringWithFormat:NSLocalizedString(@"test_name_finished", nil), NSLocalizedString(test_name, nil)]];
}

-(void)reloadTest{
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    [self.runButton setTitle:[NSString stringWithFormat:@"   %@   ", NSLocalizedString(@"run", nil)] forState:UIControlStateNormal];
    if (current.running){
        [self.indicator setHidden:FALSE];
        [self.runButton setHidden:TRUE];
        [self.indicator startAnimating];
    }
    else {
        [self.indicator setHidden:TRUE];
        [self.runButton setHidden:FALSE];
        [self.indicator stopAnimating];
    }
}

-(IBAction)runTest:(id)sender{
    NetworkMeasurement *current = [currentTests getTestWithName:testName];
    [current run];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
}

-(IBAction)learn_more:(id)sender{
    if ([testName isEqualToString:@"web_connectivity"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/nettest/web-connectivity/"]];
    else if ([testName isEqualToString:@"http_invalid_request_line"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/nettest/http-invalid-request-line/"]];
    else if ([testName isEqualToString:@"ndt_test"])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://ooni.torproject.org/nettest/ndt/"]];
}

@end
