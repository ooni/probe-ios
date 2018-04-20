#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"
#import "TestUtility.h"

@interface TestDetailsViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) Measurement *measurement;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *labelDate;
@property (nonatomic, strong) IBOutlet UILabel *labelDateDetail;
@property (nonatomic, strong) IBOutlet UILabel *labelNetwork;
@property (nonatomic, strong) IBOutlet UILabel *labelNetworkDetail;
@property (nonatomic, strong) IBOutlet UILabel *labelCountry;
@property (nonatomic, strong) IBOutlet UILabel *labelCountryDetail;
@property (nonatomic, strong) IBOutlet UILabel *labelRuntime;
@property (nonatomic, strong) IBOutlet UILabel *labelRuntimeDetail;

@end
