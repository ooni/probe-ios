#import "DashDetailsViewController.h"
#import "GRMustache.h"

@interface DashDetailsViewController ()

@end

@implementation DashDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Summary *summary = [self.result getSummary];
    NSString *rendering = [GRMustacheTemplate renderObject:@{ @"VideoQuality": [summary getVideoQuality:YES] } fromString:NSLocalizedString(@"TestResults.Details.Performance.Dash.VideoWithoutBuffering", nil) error:NULL];
    [self.titleLabel setText:[summary getVideoQuality:YES]];
    [self.subtitleLabel setText:rendering];
    [self.bitrateTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.Dash.MedianBitrate", nil)];
    [self.bitrateValueLabel setText:[summary getMedianBitrate]];
    [self.bitrateUnitLabel setText:@""];
    [self.delayTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.Dash.PlayoutDelay", nil)];
    [self.delayValueLabel setText:[summary getPlayoutDelay]];
    [self.delayUnitLabel setText:@""];
}


@end
