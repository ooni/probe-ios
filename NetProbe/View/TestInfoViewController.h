// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>

@interface TestInfoViewController : UIViewController

@property (nonatomic, strong) IBOutlet NSString *fileName;
@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

