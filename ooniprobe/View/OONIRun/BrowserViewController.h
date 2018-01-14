#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UIWebViewDelegate> {
    int urlIndex;
    NSError *lastError;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSArray *urlList;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *openMirrorButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *nextButton;

@end
