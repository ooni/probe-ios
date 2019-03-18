#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"

@interface UploadFooterViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) Measurement *measurement;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *uploadButton;

@property (assign) bool upload_all;

@end
