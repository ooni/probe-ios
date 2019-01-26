#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>
#import <QuartzCore/QuartzCore.h>
#import "TestUtility.h"
#import "Suite.h"

@interface TestRunningViewController : UIViewController {
    float totalTests;
    LOTAnimationView *animation;
    int totalRuntime;
}


@property (nonatomic, strong) AbstractSuite *testSuite;
//@property (nonatomic, strong) Result *result;

@property (strong, nonatomic) IBOutlet UILabel *runningTestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;
@property (strong, nonatomic) IBOutlet UIView *animationView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *etaLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *logLabel;
@property (assign) bool presenting;

@end
