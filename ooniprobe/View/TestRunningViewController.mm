#import "TestRunningViewController.h"

@interface TestRunningViewController ()

@end

@implementation TestRunningViewController
@synthesize testName, currentTest;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([testName isEqualToString:@"websites"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_pink7 alpha:1.0f]];
        currentTest = [[WCNetworkTest alloc] init];
    }
    else if ([testName isEqualToString:@"performance"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_cyan7 alpha:1.0f]];
        currentTest = [[SPNetworkTest alloc] init];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow7 alpha:1.0f]];
        currentTest = [[MBNetworkTest alloc] init];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_teal7 alpha:1.0f]];
        currentTest = [[IMNetworkTest alloc] init];
    }
    
    if (currentTest){
        totalTests = [currentTest.mkNetworkTests count];
        [currentTest run];
    }
    
    self.progressBar.layer.cornerRadius = 15;
    self.progressBar.layer.masksToBounds = YES;

    [self.runningTestsLabel setText:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"running_tests", nil)]];
    [self.testNameLabel setText:NSLocalizedString(self.testName, nil)];
    [self.etaLabel setText:[NSString stringWithFormat:@"%@:", NSLocalizedString(@"estimated_time_remaining", nil)]];
    
    //TODO
    [self.timeLabel setText:[NSString stringWithFormat:@"0 seconds"]];
    [self.currentTestLabel setText:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"updateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkTestEnded) name:@"networkTestEnded" object:nil];

    //NOT USED
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testEnded) name:@"testEnded" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

/*
-(void)testEnded{
    //TODO completion
}
*/

-(void)networkTestEnded{
    //TODO toast?
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
