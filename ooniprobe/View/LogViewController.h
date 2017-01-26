// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.


#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface LogViewController : UIViewController

@property (nonatomic, strong) NSString *log_file;
@property (nonatomic, strong) IBOutlet UITextView *logView;

@end
