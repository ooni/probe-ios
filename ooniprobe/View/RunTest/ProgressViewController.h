#import <UIKit/UIKit.h>
#import "RunningTest.h"

@interface ProgressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *runningTestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;

@end

