#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"
#import "TestUtility.h"
#import "LogViewController.h"
#import "JTImageLabel.h"

@interface TestDetailsViewController : UIViewController {
    NSString *segueType;
}

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) Measurement *measurement;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *runtimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *runtimeDetailLabel;
@property (nonatomic, strong) IBOutlet UIButton *viewLogButton;
@property (nonatomic, strong) IBOutlet UIButton *rawDataButton;

@end
