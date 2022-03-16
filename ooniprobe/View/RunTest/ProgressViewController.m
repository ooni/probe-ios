#import "ProgressViewController.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testStarted:) name:@"testStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"updateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkTestEndedUI) name:@"networkTestEndedUI" object:nil];
    UITapGestureRecognizer *singleFingerTap =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    [self.runningTestsLabel setText:NSLocalizedString(@"Dashboard.Running.Running", nil)];
    [self.testNameLabel setText:NSLocalizedString(@"Dashboard.Running.PreparingTest", nil)];
    self.progressBar.layer.cornerRadius = 0;
    self.progressBar.layer.masksToBounds = YES;
    [self.progressBar setProgress:0 animated:YES];
    [self updateView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateView];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    [self performSegueWithIdentifier:@"toTestRun" sender:self];
}

-(void)testStarted:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *name = [userInfo objectForKey:@"name"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.testNameLabel setText:[LocalizationUtility getNameForTest:name]];
    });
    [self updateView];
}


-(void)updateProgress:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *prog = [userInfo objectForKey:@"prog"];
    int totalRuntime = 0;
    for (AbstractSuite *n in [RunningTest currentTest].iTestSuites) {
        totalRuntime += n.getRuntime;
    }

    float previousProgress = 0;
    for (AbstractSuite *n in [RunningTest currentTest].iTestSuites) {
        if (![[RunningTest currentTest].testSuites containsObject:n]) {
            previousProgress += n.getRuntime;
        }
    }
    float totalTests = [RunningTest currentTest].testSuite.totalTests;
    int index = [RunningTest currentTest].testSuite.measurementIdx;
    float prevProgress = index/totalTests;
    float ratio = [RunningTest currentTest].testSuite.getRuntime/(float)totalRuntime;
    float progress = ([prog floatValue]/totalTests)+prevProgress;
    progress = ((previousProgress/(float)totalRuntime)+(progress*ratio));
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressBar setProgress:progress animated:YES];
    });
}

-(void)networkTestEndedUI{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressBar setProgress:0 animated:YES];
    });
    [self updateView];
}

-(void)updateView{
    if ([RunningTest currentTest].isTestRunning){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle];
            [self.view setHidden:NO];
        });
    }
    else
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setHidden:YES];
        });
}

-(void)setTitle{
    if ([RunningTest currentTest].testRunning.isPreparing)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.testNameLabel setText:NSLocalizedString(@"Dashboard.Running.PreparingTest", nil)];
        });
    else
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.testNameLabel setText:[LocalizationUtility getNameForTest:[RunningTest currentTest].testRunning.name]];
        });
}

@end
