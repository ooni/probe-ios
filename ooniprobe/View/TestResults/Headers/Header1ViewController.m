#import "Header1ViewController.h"
#import "SettingsUtility.h"
@interface Header1ViewController ()

@end

@implementation Header1ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultUpdated:) name:@"resultUpdated" object:nil];

    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];
    [self addLabels];
    [self reloadMeasurement];
}

- (void)resultUpdated:(NSNotification *)notification
{
    result = [notification object];
    [self reloadMeasurement];
}

-(void)addLabels{
    if ([result.name isEqualToString:@"websites"]){
        [self.view4 setHidden:YES];
        [self.label1Top setText:NSLocalizedString(@"tested", nil)];
        [self.label1Bottom setText:NSLocalizedString(@"sites", nil)];
        [self.label2Top setText:NSLocalizedString(@"blocked", nil)];
        [self.label2Bottom setText:NSLocalizedString(@"sites", nil)];
        [self.label3Top setText:NSLocalizedString(@"reachable", nil)];
        [self.label3Bottom setText:NSLocalizedString(@"found", nil)];
    }
    else if ([result.name isEqualToString:@"instant_messaging"]){
        [self.view4 setHidden:YES];
        [self.label1Top setText:NSLocalizedString(@"tested", nil)];
        [self.label1Bottom setText:NSLocalizedString(@"apps", nil)];
        [self.label2Top setText:NSLocalizedString(@"blocked", nil)];
        [self.label2Bottom setText:NSLocalizedString(@"apps", nil)];
        [self.label3Top setText:NSLocalizedString(@"reachable", nil)];
        [self.label3Bottom setText:NSLocalizedString(@"apps", nil)];
    }
    else if ([result.name isEqualToString:@"performance"]){
        if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
            [self addLine:self.view3];
        }
        else {
            [self addLine:self.view4];
        }
        [self.label1Top setText:NSLocalizedString(@"video", nil)];
        [self.label1Bottom setText:NSLocalizedString(@"quality", nil)];
        [self.label2Top setText:NSLocalizedString(@"upload", nil)];
        [self.label3Top setText:NSLocalizedString(@"download", nil)];
        [self.label4Top setText:NSLocalizedString(@"ping", nil)];
        [self.label4Bottom setText:NSLocalizedString(@"ms", nil)];
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
    Summary *summary = [self.result getSummary];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([result.name isEqualToString:@"websites"]){
            [self.label1Central setText:[NSString stringWithFormat:@"%d", summary.totalMeasurements]];
            [self.label2Central setText:[NSString stringWithFormat:@"%d", summary.blockedMeasurements]];
            [self.label3Central setText:[NSString stringWithFormat:@"%d", summary.okMeasurements]];
        }
        else if ([result.name isEqualToString:@"instant_messaging"]){
            [self.label1Central setText:[NSString stringWithFormat:@"%d", summary.totalMeasurements]];
            [self.label2Central setText:[NSString stringWithFormat:@"%d", summary.blockedMeasurements]];
            [self.label3Central setText:[NSString stringWithFormat:@"%d", summary.okMeasurements]];
        }
        else if ([result.name isEqualToString:@"performance"]){
            [self.label1Central setText:[summary getVideoQuality:YES]];
            [self.label2Central setText:[summary getUpload]];
            [self.label2Bottom setText:[summary getUploadUnit]];
            [self.label3Central setText:[summary getDownload]];
            [self.label3Bottom setText:[summary getDownloadUnit]];
            [self.label4Central setText:[summary getPing]];
        }
    });
}

-(void)addLine:(UIView*)view{
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, view.frame.size.height)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:lineView];
}

@end
