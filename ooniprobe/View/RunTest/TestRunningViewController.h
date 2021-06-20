#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>
#import <QuartzCore/QuartzCore.h>
#import "TestUtility.h"
#import "Suite.h"
#import "Engine.h"

@interface TestRunningViewController : UIViewController {
    float totalTests;
    LOTAnimationView *animation;
    int totalRuntime;
    AbstractSuite *testSuite;
}

@property (nonatomic, strong) NSMutableArray *testSuites;
@property (strong, nonatomic) IBOutlet UILabel *runningTestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;
@property (strong, nonatomic) IBOutlet UIView *animationView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *etaLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *logLabel;
@property (strong, nonatomic) IBOutlet UIButton *interruptButton;
@property (strong, nonatomic) IBOutlet UIButton *minimizeButton;
@property (assign) bool presenting;

@end
