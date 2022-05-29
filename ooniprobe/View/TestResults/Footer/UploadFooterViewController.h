#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"
#import "LoggerArray.h"

/// This view controller manage the upload footer and its method. It's contained as sub view in 3 other views
@interface UploadFooterViewController : UIViewController

/// result contains the Result that the upload footer is about to upload
@property (nonatomic, strong) Result *result;

/// measurement contains the the Measurement that the upload footer is about to upload
@property (nonatomic, strong) Measurement *measurement;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *uploadButton;

// upload_all is a bool used to indicate if the footer should upload a measurement (one) or a result (all)
@property (assign) bool upload_all;

@property (nonatomic, strong) LoggerArray* logger;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@property (atomic, assign) BOOL canceled;

@end
