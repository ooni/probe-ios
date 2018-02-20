#import "Header2ViewController.h"

@interface Header2ViewController ()

@end

@implementation Header2ViewController
@synthesize result;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView setBackgroundColor:[SettingsUtility getColorForTest:result.name]];
}


@end
