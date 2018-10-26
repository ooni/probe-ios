#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "TestUtility.h"
#import "Result.h"

@interface Header3ViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *countryLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *websitesLabel;
@property (nonatomic, strong) IBOutlet UILabel *websitesDetailLabel;

@end
