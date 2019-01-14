#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"
#import "TestUtility.h"
#import "LogViewController.h"
#import "RHMarkdownLabel.h"
#import "MessageUtility.h"

@interface TestDetailsViewController : UIViewController {
    NSString *segueType;
}

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) Measurement *measurement;
@property (nonatomic, strong) IBOutlet UIView *headerView;

@end
