#import "NdtDetailsViewController.h"

@interface NdtDetailsViewController ()

@end

@implementation NdtDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Summary *summary = [self.result getSummary];
    [self.downloadTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Download", nil)];
    [self.downloadValueLabel setText:[summary getDownload]];
    [self.downloadUnitLabel setText:[summary getUploadUnit]];

    [self.uploadTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Upload", nil)];
    [self.uploadValueLabel setText:[summary getUpload]];
    [self.uploadUnitLabel setText:[summary getUploadUnit]];

    [self.pingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Ping", nil)];
    [self.pingValueLabel setText:[summary getPing]];

    [self.serverTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Server", nil)];
    [self.serverValueLabel setText:[summary getServer]];
    
    [self.packetlossTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.PacketLoss", nil)];
    [self.packetlossValueLabel setText:[summary getPacketLoss]];

    [self.outoforderTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.OutOfOrder", nil)];
    [self.outoforderValueLabel setText:[summary getOutOfOrder]];

    [self.averagepingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.AveragePing", nil)];
    [self.averagepingValueLabel setText:[summary getAveragePing]];

    [self.maxpingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.MaxPing", nil)];
    [self.maxpingValueLabel setText:[summary getMaxPing]];

    [self.mssTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.MSS", nil)];
    [self.mssValueLabel setText:[summary getMSS]];

    [self.timeoutsTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Timeouts", nil)];
    [self.timeoutsValueLabel setText:[summary getTimeouts]];
}

@end
