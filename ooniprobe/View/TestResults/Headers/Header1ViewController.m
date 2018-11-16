#import "Header1ViewController.h"
#import "SettingsUtility.h"
@interface Header1ViewController ()

@end

@implementation Header1ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];

    [self.headerView setBackgroundColor:[TestUtility getColorForTest:result.test_group_name]];
    [self addLabels];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurement];
}

-(void)addLabels{
    if ([result.test_group_name isEqualToString:@"websites"]){
        [self.view4 setHidden:YES];
    }
    else if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        [self.view4 setHidden:YES];
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
            [self addLine:self.view3];
        }
        else {
            [self addLine:self.view4];
        }
        [self.label1Top setText:NSLocalizedString(@"TestResults.Summary.Performance.Hero.Video", nil)];
        [self.label1Bottom setText:NSLocalizedString(@"TestResults.Summary.Performance.Hero.Video.Quality", nil)];
        [self.label2Top setText:NSLocalizedString(@"TestResults.Summary.Performance.Hero.Upload", nil)];
        [self.label3Top setText:NSLocalizedString(@"TestResults.Summary.Performance.Hero.Download", nil)];
        [self.label4Top setText:NSLocalizedString(@"TestResults.Summary.Performance.Hero.Ping", nil)];
        [self.label4Bottom setText:NSLocalizedString(@"TestResults.ms", nil)];
    }
    [self addLine:self.view2];
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        [self addLine:self.view1];
    }
    else {
        [self addLine:self.view3];
    }

}
-(void)reloadMeasurement{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([result.test_group_name isEqualToString:@"websites"]){
            [self.label1Top setText:[LocalizationUtility getSingularPlural:result.totalMeasurements :@"TestResults.Summary.Websites.Hero.Tested"]];
            [self.label2Top setText:[LocalizationUtility getSingularPlural:result.anomalousMeasurements :@"TestResults.Summary.Websites.Hero.Blocked"]];
            [self.label3Top setText:[LocalizationUtility getSingularPlural:result.okMeasurements :@"TestResults.Summary.Websites.Hero.Reachable"]];
            [self.label1Central setText:[NSString stringWithFormat:@"%ld", result.totalMeasurements]];
            [self.label2Central setText:[NSString stringWithFormat:@"%ld", result.anomalousMeasurements]];
            [self.label3Central setText:[NSString stringWithFormat:@"%ld", result.okMeasurements]];
            [self.label1Bottom setText:[LocalizationUtility getSingularPlural:result.totalMeasurements :@"TestResults.Summary.Websites.Hero.Sites"]];
            [self.label2Bottom setText:[LocalizationUtility getSingularPlural:result.anomalousMeasurements :@"TestResults.Summary.Websites.Hero.Sites"]];
            [self.label3Bottom setText:[LocalizationUtility getSingularPlural:result.okMeasurements :@"TestResults.Summary.Websites.Hero.Sites"]];
        }
        else if ([result.test_group_name isEqualToString:@"instant_messaging"]){
            [self.label1Top setText:[LocalizationUtility getSingularPlural:result.totalMeasurements :@"TestResults.Summary.InstantMessaging.Hero.Tested"]];
            [self.label2Top setText:[LocalizationUtility getSingularPlural:result.anomalousMeasurements :@"TestResults.Summary.InstantMessaging.Hero.Blocked"]];
            [self.label3Top setText:[LocalizationUtility getSingularPlural:result.okMeasurements :@"TestResults.Summary.Websites.Hero.Reachable"]];
            [self.label1Central setText:[NSString stringWithFormat:@"%ld", result.totalMeasurements]];
            [self.label2Central setText:[NSString stringWithFormat:@"%ld", result.anomalousMeasurements]];
            [self.label3Central setText:[NSString stringWithFormat:@"%ld", result.okMeasurements]];
            [self.label1Bottom setText:[LocalizationUtility getSingularPlural:result.totalMeasurements :@"TestResults.Summary.InstantMessaging.Hero.Apps"]];
            [self.label2Bottom setText:[LocalizationUtility getSingularPlural:result.anomalousMeasurements :@"TestResults.Summary.InstantMessaging.Hero.Apps"]];
            [self.label3Bottom setText:[LocalizationUtility getSingularPlural:result.okMeasurements :@"TestResults.Summary.InstantMessaging.Hero.Apps"]];
        }
        else if ([result.test_group_name isEqualToString:@"performance"]){
            TestKeys *testKeysNdt = [result getMeasurement:@"ndt"].testKeysObj;
            TestKeys *testKeysDash = [result getMeasurement:@"dash"].testKeysObj;
            [self.label1Central setText:[testKeysDash getVideoQuality:NO]];
            [self.label2Central setText:[testKeysNdt getUpload]];
            [self.label2Bottom setText:[testKeysNdt getUploadUnit]];
            [self.label3Central setText:[testKeysNdt getDownload]];
            [self.label3Bottom setText:[testKeysNdt getDownloadUnit]];
            [self.label4Central setText:[testKeysNdt getPing]];
        }
    });
}


-(void)addLine:(UIView*)view{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, view.frame.size.height)];
    [lineView setBackgroundColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [view addSubview:lineView];
}

@end
