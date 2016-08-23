// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ResultViewController : UIViewController <UIActionSheetDelegate> 

@property (nonatomic, strong)NSString *json_file;
@property (nonatomic, strong) WKWebView *webView;

@end
