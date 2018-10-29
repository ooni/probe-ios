#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "TestUtility.h"
#import "Result.h"

@interface Header2ViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *dateAndTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateAndTimeDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *dataUsageLabel;
@property (nonatomic, strong) IBOutlet UILabel *dataUsageUploadLabel;
@property (nonatomic, strong) IBOutlet UILabel *dataUsageDownloadLabel;
@property (nonatomic, strong) IBOutlet UILabel *runtimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *runtimeDetailLabel;

@end
