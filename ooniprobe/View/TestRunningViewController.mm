#import "TestRunningViewController.h"

@interface TestRunningViewController ()

@end

@implementation TestRunningViewController
@synthesize testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([testName isEqualToString:@"websites"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_pink7 alpha:1.0f]];
        [[[WCNetworkTest alloc] init] run];
    }
    else if ([testName isEqualToString:@"performance"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_cyan7 alpha:1.0f]];
        [[[SPNetworkTest alloc] init] run];
    }
    else if ([testName isEqualToString:@"middle_boxes"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow7 alpha:1.0f]];
        [[[MBNetworkTest alloc] init] run];
    }
    else if ([testName isEqualToString:@"instant_messaging"]){
        [self.view setBackgroundColor:[UIColor colorWithRGBHexString:color_teal7 alpha:1.0f]];
        [[[IMNetworkTest alloc] init] run];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
