#import <UIKit/UIKit.h>
#import "RoundedButton.h"
#import "Tests.h"
#import "UIView+Toast.h"

@interface TestInfoViewController : UIViewController {
    Tests *currentTests;
}

@property (nonatomic, strong) IBOutlet NSString *testName;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet RoundedButton *runButton;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@end

