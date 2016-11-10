// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    items = [self getItems];
    self.title = NSLocalizedString(@"test_result", nil);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputSelected:) name:@"inputSelected" object:nil];
    [self loadScreen:[items objectAtIndex:0]];
    if ([items count] > 1){
        [self performSegueWithIdentifier:@"toResultSelector" sender:self];
        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectTest)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:closeBtn, nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) inputSelected:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    [self loadScreen:[items objectAtIndex:[[userInfo objectForKey:@"input_id"] longValue]]];
}

-(void) loadScreen :(NSString*) content{
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
    //BUG FIX: when alloc the second time the webview goes under top bar
    if (self.webView != nil) {
        [self.webView removeFromSuperview];
        frame.origin.y +=64;
        frame.size.height -= 64;
    }
    
    self.webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:htmlData baseURL: [NSURL fileURLWithPath:pathToHtml]];
}

-(void) selectTest{
    [self performSegueWithIdentifier:@"toResultSelector" sender:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1){
        [self loadScreen:[items objectAtIndex:buttonIndex]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSArray*)getItems{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.json_file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *content = @"";
    if([fileManager fileExistsAtPath:filePath]) {
        content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        //Cut out the last \n
        if ([content length] > 0) {
            content = [content substringToIndex:[content length]-1];
        }
    }
    return [content componentsSeparatedByString:@"\n"];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navController = [segue destinationViewController];
    ResultSelectorViewController *rvc = (ResultSelectorViewController *)([navController viewControllers][0]);
    //ResultSelectorViewController *rvc = [segue destinationViewController];
    [rvc setItems:items];
}

@end
