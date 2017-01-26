// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController
@synthesize content, testName;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"view_log", nil);
    [self loadScreen];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(testName, nil);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.title = nil;
}

-(void) loadScreen{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController* userController = [[WKUserContentController alloc] init];

    // Here we sanitize the content. Note: order matters.
    content = [content stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    content = [content stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];

    NSString* MeasurementJSON = [NSString stringWithFormat:@"\n var MeasurementJSON = {  \n"
                                 "get: function() {  \n"
                                 "return "
                                 "'%s';"
                                 "   } \n"
                                 "};", [content UTF8String]]; // Cast to c type string

    WKUserScript* userScript = [[WKUserScript alloc]initWithSource:MeasurementJSON
                                                     injectionTime: WKUserScriptInjectionTimeAtDocumentStart
                                                  forMainFrameOnly:NO];
    [userController addUserScript:userScript];
    configuration.userContentController = userController;
    
    NSString *pathToHtml = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *htmlData = [NSString stringWithContentsOfFile:pathToHtml encoding:NSUTF8StringEncoding error:NULL];

    CGRect frame = self.view.frame;
    frame.size.height -= 64;

    //BUG FIX: when alloc the second time the webview goes under top bar
    /*if (self.webView != nil) {
        [self.webView removeFromSuperview];
        //frame.origin.y +=64;
        frame.size.height -= 64;
    }*/
    
    self.webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:htmlData baseURL: [NSURL fileURLWithPath:pathToHtml]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //This screen is hidden for the moment
    if ([[segue identifier] isEqualToString:@"toLog"]){
        LogViewController *vc = (LogViewController * )segue.destinationViewController;
        [vc setLog_file:self.log_file];
    }
}

@end
