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
    NSString *pathToFile = [[NSBundle mainBundle] pathForResource:self.fileName ofType:self.fileType];
    NSString *fileData = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:NULL];
    if ([self.fileType isEqualToString:@"md"])
        [self.webView loadMarkdownString:fileData atBaseURL:[[NSBundle mainBundle] bundleURL] withStylesheet:iOSCssData];
    else if ([self.fileType isEqualToString:@"html"])
        [self.webView loadHTMLString:fileData baseURL:[[NSBundle mainBundle] bundleURL]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
