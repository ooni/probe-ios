
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface LogViewController : UIViewController

@property (nonatomic, strong) NSString *log_file;
@property (nonatomic, strong) IBOutlet UITextView *logView;

@end
