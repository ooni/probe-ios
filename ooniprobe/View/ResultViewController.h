// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ResultSelectorViewController.h"
#import "LogViewController.h"

@interface ResultViewController : UIViewController

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) IBOutlet NSString *testName;
@property (nonatomic, strong) NSString *log_file;

@end
