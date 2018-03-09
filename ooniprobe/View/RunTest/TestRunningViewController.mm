#import "TestRunningViewController.h"

@interface TestRunningViewController ()

@end

@implementation TestRunningViewController
@synthesize currentTest;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[SettingsUtility getColorForTest:currentTest.result.name]];
    
    if (currentTest){
        totalTests = [currentTest.mkNetworkTests count];
        [currentTest run];
    }
    
    self.progressBar.layer.cornerRadius = 15;
    self.progressBar.layer.masksToBounds = YES;

    [self.runningTestsLabel setText:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"running_tests", nil)]];
    [self.testNameLabel setText:NSLocalizedString(currentTest.result.name, nil)];
    [self.etaLabel setText:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"estimated_time_remaining", nil)]];
    [self.currentTestLabel setText:@""];

    //TODO
    [self.timeLabel setText:[NSString stringWithFormat:@"0 seconds"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"updateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkTestEnded) name:@"networkTestEnded" object:nil];

    //NOT USED
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testEnded) name:@"testEnded" object:nil];
    animation = [LOTAnimationView animationNamed:@"checkMark"];
    //[animation setBackgroundColor:[SettingsUtility getColorForTest:testName]];
    animation.contentMode = UIViewContentModeScaleAspectFit;
    [self.animationView addSubview:animation];
    CGRect c = self.animationView.bounds;
    animation.frame = CGRectMake(0, 0, c.size.width, c.size.height);
    [self.animationView setNeedsLayout];
    
    if ([SettingsUtility getSettingWithName:@"keep_screen_on"]){
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
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
    NSNumber *index = [userInfo objectForKey:@"index"];
    float prevProgress = [index floatValue]/totalTests;
    float progress = ([prog floatValue]/totalTests)+prevProgress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.currentTestLabel setText:[NSString stringWithFormat:@"... %@ %@", [NSLocalizedString(@"running", nil) lowercaseString], NSLocalizedString(name, nil)]];
        [self.progressBar setProgress:progress animated:YES];
    });
    [animation playWithCompletion:^(BOOL animationFinished) {
        //[animation removeFromSuperview];
    }];

}

/*
-(void)testEnded{
    //TODO completion
}
*/

-(void)networkTestEnded{
    //TODO toast?
    [self dismissViewControllerAnimated:TRUE completion:^{
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTests" object:nil];
    }];
}

@end
