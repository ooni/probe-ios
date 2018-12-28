#import "TestRunningViewController.h"
#import "Suite.h"

@interface TestRunningViewController ()
@end

@implementation TestRunningViewController

@synthesize testSuite;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[TestUtility getColorForTest:testSuite.name]];
    totalRuntime = [testSuite getRuntime];
    NSString *time = NSLocalizedFormatString(@"Dashboard.Running.Seconds", [NSString stringWithFormat:@"%d", totalRuntime]);
    [self.timeLabel setText:time];
    [self.testNameLabel setText:NSLocalizedString(@"Dashboard.Running.PreparingTest", nil)];

    [self runTest];
    self.progressBar.layer.cornerRadius = 7.5;
    self.progressBar.layer.masksToBounds = YES;
    [self.progressBar setTrackTintColor:[UIColor colorWithRGBHexString:color_white alpha:0.2f]];
    [self.runningTestsLabel setText:NSLocalizedString(@"Dashboard.Running.Running", nil)];
    [self.logLabel setText:@""];
    [self.etaLabel setText:NSLocalizedString(@"Dashboard.Running.EstimatedTimeLeft", nil)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"updateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkTestEnded) name:@"networkTestEnded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLog:) name:@"updateLog" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError) name:@"showError" object:nil];

    //Keep screen on
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addAnimation];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

-(void)runTest{
    if (testSuite != nil){
        totalTests = [testSuite.testList count];
        [testSuite runTestSuite];
    }
}

-(void)addAnimation{
    animation = [LOTAnimationView animationNamed:testSuite.name];
    animation.contentMode = UIViewContentModeScaleAspectFit;
    CGRect c = self.animationView.bounds;
    animation.frame = CGRectMake(0, 0, c.size.width, c.size.height);
    [self.animationView setNeedsLayout];
    [self.animationView setClipsToBounds:YES];
    [self.animationView addSubview:animation];
    [animation setLoopAnimation:YES];
    [animation play];
}

-(void)updateLog:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *log = [userInfo objectForKey:@"log"];
    [self.logLabel setText:log];
}

-(void)updateProgress:(NSNotification *)notification{
    /*
     Format string with minute and seconds
     https://stackoverflow.com/questions/27519533/how-to-format-date-in-to-string-like-as-one-days-ago-minutes-ago-in-ios
     https://stackoverflow.com/questions/2927028/how-do-i-get-hour-and-minutes-from-nsdate
     */
    NSDictionary *userInfo = notification.userInfo;
    NSString *name = [userInfo objectForKey:@"name"];
    NSNumber *prog = [userInfo objectForKey:@"prog"];
    //TODO-2.1 this doesn't take in consideration different test runtimes, only the total
    //But still fixes https://github.com/ooni/probe/issues/805
    int index = testSuite.measurementIdx;
    float prevProgress = index/totalTests;
    float progress = ([prog floatValue]/totalTests)+prevProgress;
    long eta = totalRuntime;
    if (progress > 0) {
        eta = lroundf(totalRuntime - progress * totalRuntime);
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressBar setProgress:progress animated:YES];
        NSString *time = NSLocalizedFormatString(@"Dashboard.Running.Seconds", [NSString stringWithFormat:@"%ld", eta]);
        [self.timeLabel setText:time];
        [self.testNameLabel setText:[LocalizationUtility getNameForTest:name]];

    });
    [animation playWithCompletion:^(BOOL animationFinished) {}];

}

-(void)networkTestEnded{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_presenting){
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:TRUE completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goToResults" object:nil];
            }];
        }
        else {
            [self dismissViewControllerAnimated:TRUE completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goToResults" object:nil];
            }];
        }
    });

}

-(void)showError{
    [MessageUtility alertWithTitle:@"Modal.Error" message:@"Modal.Error.CantDownloadURLs" inView:self];
}

@end
