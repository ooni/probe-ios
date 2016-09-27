// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ResultSelectorViewController.h"

@interface ResultViewController : UIViewController <UIActionSheetDelegate> {
    NSArray *items;
}

@property (nonatomic, strong) NSString *json_file;
@property (nonatomic, strong) WKWebView *webView;

@end
