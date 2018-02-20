#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "Result.h"

@interface Header2ViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *labelNetworkType;
@property (nonatomic, strong) IBOutlet UILabel *labelNetwork;
@property (nonatomic, strong) IBOutlet UILabel *labelAsn;
@property (nonatomic, strong) IBOutlet UILabel *labelDataUsage;
@property (nonatomic, strong) IBOutlet UILabel *labelDataUsageDetail;
@property (nonatomic, strong) IBOutlet UILabel *labelRuntime;
@property (nonatomic, strong) IBOutlet UILabel *labelRuntimeDetail;

@end
