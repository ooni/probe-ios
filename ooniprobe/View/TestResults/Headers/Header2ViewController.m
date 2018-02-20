#import "Header2ViewController.h"

@interface Header2ViewController ()

@end

@implementation Header2ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];
    [self.labelNetworkType setText:NSLocalizedString(result.networkType, nil)];
    [self.labelNetwork setText:NSLocalizedString(@"network", nil)];
    [self.labelAsn setText:NSLocalizedString(@"network", nil)];
    [self.labelDataUsage setText:NSLocalizedString(@"data_usage", nil)];
    [self.labelDataUsageDetail setText:NSLocalizedString(@"data_usage", nil)];
    [self.labelRuntime setText:NSLocalizedString(@"runtime", nil)];
    [self.labelRuntimeDetail setText:NSLocalizedString(@"runtime", nil)];
}


@end
