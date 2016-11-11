// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "TestInfoViewController.h"

@interface TestInfoViewController ()

@end

@implementation TestInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *pathToiOSCss = [[NSBundle mainBundle] pathForResource:@"setup-mobile" ofType:@"css"];
    NSString *iOSCssData = [NSString stringWithContentsOfFile:pathToiOSCss encoding:NSUTF8StringEncoding error:NULL];
    NSString *pathToHtml = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"html"];
    NSString *htmlData = [NSString stringWithContentsOfFile:pathToHtml encoding:NSUTF8StringEncoding error:NULL];
    NSString *html = [NSString stringWithFormat:@"<head><style>%@</style></head>%@", iOSCssData, htmlData];
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
