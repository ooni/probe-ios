#import "NdtDetailsViewController.h"

@interface NdtDetailsViewController ()

@end

@implementation NdtDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Summary *summary = [self.result getSummary];
/*
    [self.label1Central setText:[summary getVideoQuality:YES]];
    [self.label2Central setText:[summary getUpload]];
    [self.label2Bottom setText:[summary getUploadUnit]];
    [self.label3Central setText:[summary getDownload]];
    [self.label3Bottom setText:[summary getDownloadUnit]];
    [self.label4Central setText:[summary getPing]];
*/
    [self.downloadTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Download", nil)];
    [self.uploadTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Upload", nil)];
    [self.pingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Ping", nil)];
    [self.serverTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Server", nil)];
    [self.packetlossTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.PacketLoss", nil)];
    [self.outoforderTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.OutOfOrder", nil)];
    [self.averagepingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.AveragePing", nil)];
    [self.maxpingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.MaxPing", nil)];
    [self.mssTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.MSS", nil)];
    [self.timeoutsTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Timeouts", nil)];
}

@end
