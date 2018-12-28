#import "TestRunningViewController.h"
#import "Suite.h"

@interface TestRunningViewController ()
@end

@implementation TestRunningViewController

@synthesize testSuite;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[TestUtility getColorForTest:testSuite.name]];

    /*
    if ([testSuite.name isEqualToString:@"websites"]){
        if (urls == nil){
            //Download urls and then alloc class
            [TestUtility downloadUrls:^(NSArray *urls) {
                if (urls != nil && [urls count] > 0){
                    [test setResult:result];
                    [(WebsitesSuite*)test setUrls:urls];
                    [(WebsitesSuite*)test setMaxRuntime];
                    //[self runTest];
                }
                else {
                    [MessageUtility alertWithTitle:@"Modal.Error" message:@"Modal.Error.CantDownloadURLs" inView:self];
                    [self networkTestEnded];
                }
            }];
        }
        else {
            //URLs and result already defined
            [test setResult:result];
            [(WebsitesSuite*)test setUrls:urls];
            [(WebsitesSuite*)test setMaxRuntime];
        }
    }
    else if ([testSuite.name isEqualToString:@"performance"]){
        //TODO quando chiamo sta schermata da oonirun o rerun, il test deve avere gia una testlist singola
        if (testName != nil)
            currentTest = [[PerformanceSuite alloc] initWithTest:testName andResult:result];
        else
            currentTest = [[PerformanceSuite alloc] init];
    }
    else if ([testSuite.name isEqualToString:@"middle_boxes"]){
        if (testName != nil)
            currentTest = [[MiddleBoxesSuite alloc] initWithTest:testName andResult:result];
        else
            currentTest = [[MiddleBoxesSuite alloc] init];
    }
    else if ([testSuite.name isEqualToString:@"instant_messaging"]){
        if (testName != nil)
            currentTest = [[InstantMessagingSuite alloc] initWithTest:testName andResult:result];
        else
            currentTest = [[InstantMessagingSuite alloc] init];
    }
     */
    
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
    //TODO this doesn't take in consideration different test runtimes, only the total
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
