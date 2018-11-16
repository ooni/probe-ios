#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"

@interface NdtDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UILabel *downloadTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *downloadValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *downloadUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *uploadTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *uploadValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *uploadUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *pingTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *pingValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *pingUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *serverTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *serverValueLabel;

@property (nonatomic, strong) IBOutlet UILabel *packetlossTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *packetlossValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *packetlossUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *outoforderTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *outoforderValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *outoforderUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *averagepingTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *averagepingValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *averagepingUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *maxpingTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxpingValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxpingUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *mssTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *mssValueLabel;

@property (nonatomic, strong) IBOutlet UILabel *timeoutsTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeoutsValueLabel;

@end
