#import <UIKit/UIKit.h>
#import "Measurement.h"

@interface LogViewController : UIViewController

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) Measurement *measurement;
@property (nonatomic, strong) IBOutlet UITextView *textView;

@end
