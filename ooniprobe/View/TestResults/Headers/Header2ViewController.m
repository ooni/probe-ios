#import "Header2ViewController.h"

@interface Header2ViewController ()

@end

@implementation Header2ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];
    
    [self.headerView setBackgroundColor:[TestUtility getBackgroundColorForTest:result.test_group_name]];
    [self.dateAndTimeLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DateAndTime", nil)];
    [self.dataUsageLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.DataUsage", nil)];
    [self.runtimeLabel setText:NSLocalizedString(@"TestResults.Summary.Hero.Runtime", nil)];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    if (result.Id != ((Result *) [notification object]).Id) {
        return;
    }
    result = [notification object];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadMeasurement];
    });
}

-(void)reloadMeasurement{
    [self.dataUsageUploadLabel setText:[result getFormattedDataUsageUp]];
    [self.dataUsageDownloadLabel setText:[result getFormattedDataUsageDown]];
    [self.runtimeDetailLabel setText:[NSString stringWithFormat:@"%.02f sec", [result getRuntime]]];
    [self.dateAndTimeDetailLabel setText:[result getLocalizedStartTime]];
}
@end
