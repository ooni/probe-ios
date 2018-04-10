#import <UIKit/UIKit.h>
#import "SettingsUtility.h"
#import "TestUtility.h"
#import "Result.h"

@interface Header1ViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIStackView *view1;
@property (nonatomic, strong) IBOutlet UILabel *label1Top;
@property (nonatomic, strong) IBOutlet UILabel *label1Central;
@property (nonatomic, strong) IBOutlet UILabel *label1Bottom;
@property (nonatomic, strong) IBOutlet UIStackView *view2;
@property (nonatomic, strong) IBOutlet UILabel *label2Top;
@property (nonatomic, strong) IBOutlet UILabel *label2Central;
@property (nonatomic, strong) IBOutlet UILabel *label2Bottom;
@property (nonatomic, strong) IBOutlet UIStackView *view3;
@property (nonatomic, strong) IBOutlet UILabel *label3Top;
@property (nonatomic, strong) IBOutlet UILabel *label3Central;
@property (nonatomic, strong) IBOutlet UILabel *label3Bottom;
@property (nonatomic, strong) IBOutlet UIStackView *view4;
@property (nonatomic, strong) IBOutlet UILabel *label4Top;
@property (nonatomic, strong) IBOutlet UILabel *label4Central;
@property (nonatomic, strong) IBOutlet UILabel *label4Bottom;

@end
