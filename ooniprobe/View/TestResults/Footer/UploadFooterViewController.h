#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"

//This view controller manage the upload footer and its method. It's contained as sub view in 3 other views
@interface UploadFooterViewController : UIViewController

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) Measurement *measurement;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *uploadButton;

@property (assign) bool upload_all;

@end
