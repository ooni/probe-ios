#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>
#import <QuartzCore/QuartzCore.h>
#import "NetworkTest.h"
#import "TestUtility.h"

@interface TestRunningViewController : UIViewController {
    float totalTests;
    LOTAnimationView *animation;
    NetworkTest *currentTest;
}


@property (nonatomic, strong) NSString *testSuiteName;
@property (nonatomic, strong) NSString *testName;
@property (nonatomic, strong) NSArray *urls;
@property (nonatomic, strong) Result *result;

@property (strong, nonatomic) IBOutlet UILabel *runningTestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;
@property (strong, nonatomic) IBOutlet UIView *animationView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *etaLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *logLabel;
@property (assign) bool presenting;

@end
