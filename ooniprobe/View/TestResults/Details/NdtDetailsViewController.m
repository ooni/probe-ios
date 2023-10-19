#import "NdtDetailsViewController.h"
#import "RunningTest.h"

@interface NdtDetailsViewController ()

@end

@implementation NdtDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TestKeys *testKeys = [self.measurement testKeysObj];
    [self.downloadTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Download", nil)];
    [self.downloadValueLabel setText:[testKeys getDownload]];
    [self.downloadUnitLabel setText:[testKeys getDownloadUnit]];

    [self.uploadTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Upload", nil)];
    [self.uploadValueLabel setText:[testKeys getUpload]];
    [self.uploadUnitLabel setText:[testKeys getUploadUnit]];

    [self.pingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Ping", nil)];
    [self.pingValueLabel setText:[testKeys getPing]];

    [self.serverTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.Server", nil)];
    [self.serverValueLabel setText:[testKeys getServerDetails]];
    
    [self.packetlossTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.PacketLoss", nil)];
    [self.packetlossValueLabel setText:[testKeys getPacketLoss]];

    [self.averagepingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.AveragePing", nil)];
    [self.averagepingValueLabel setText:[testKeys getAveragePing]];

    [self.maxpingTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.MaxPing", nil)];
    [self.maxpingValueLabel setText:[testKeys getMaxPing]];

    [self.mssTitleLabel setText:NSLocalizedString(@"TestResults.Details.Performance.NDT.MSS", nil)];
    [self.mssValueLabel setText:[testKeys getMSS]];

    [self.packetlossTitleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.packetlossValueLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.packetlossUnitLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        
    [self.averagepingTitleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.averagepingValueLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.averagepingUnitLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    
    [self.maxpingTitleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.maxpingValueLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.maxpingUnitLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    
    [self.mssTitleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.mssValueLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self reloadConstraints];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadConstraints];
}

-(void)reloadConstraints{
    CGFloat uploadConstraint = 64;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.uploadBarFooterConstraint.constant = uploadConstraint;
    });
}

@end
