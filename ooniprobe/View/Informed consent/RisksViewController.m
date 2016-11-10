// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "RisksViewController.h"

@interface RisksViewController ()

@end

@implementation RisksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"risks", nil);
    UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:next, nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showToast) name:@"showToastWrong" object:nil];
    
    NSString *pathToiOSCss = [[NSBundle mainBundle] pathForResource:@"setup-mobile" ofType:@"css"];
    NSString *iOSCssData = [NSString stringWithContentsOfFile:pathToiOSCss encoding:NSUTF8StringEncoding error:NULL];
    NSString *pathToHtml = [[NSBundle mainBundle] pathForResource:@"step2" ofType:@"html"];
    NSString *htmlData = [NSString stringWithContentsOfFile:pathToHtml encoding:NSUTF8StringEncoding error:NULL];
    NSString *html = [NSString stringWithFormat:@"<head><style>%@</style></head>%@", iOSCssData, htmlData];
    [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showToast{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageAlignment = NSTextAlignmentCenter;
    style.messageColor = [UIColor colorWithRed:169.0/255.0 green:68.0/255.0 blue:66.0/255.0 alpha:1.0];
    style.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0];
    [self.view makeToast:NSLocalizedString(@"wrong", nil) duration:3.0 position:CSToastPositionBottom style:style];
}


-(void)next{
    [self performSegueWithIdentifier:@"toQuiz" sender:self];
}

@end
