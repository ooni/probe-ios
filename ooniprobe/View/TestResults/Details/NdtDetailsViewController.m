#import "NdtDetailsViewController.h"

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
    
    [self.downloadTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.downloadValueLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.downloadUnitLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    
    [self.uploadTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.uploadValueLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.uploadUnitLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    
    [self.pingTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.pingValueLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.pingUnitLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    
    [self.serverTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.serverValueLabel setTextColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];

    [self.packetlossTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.packetlossValueLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.packetlossUnitLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        
    [self.averagepingTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.averagepingValueLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.averagepingUnitLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    
    [self.maxpingTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.maxpingValueLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.maxpingUnitLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    
    [self.mssTitleLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.mssValueLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
}

@end
