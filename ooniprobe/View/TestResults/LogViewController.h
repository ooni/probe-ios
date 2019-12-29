#import <UIKit/UIKit.h>
#import "Measurement.h"
#import <WebKit/WebKit.h>

@interface LogViewController : UIViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) Measurement *measurement;
@property (nonatomic, strong) IBOutlet WKWebView *webView;

@end
