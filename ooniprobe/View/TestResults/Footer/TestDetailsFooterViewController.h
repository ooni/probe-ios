#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"
#import "RHMarkdownLabel.h"

@interface TestDetailsFooterViewController : UIViewController {
    NSString *segueType;
}

@property (nonatomic, strong) Result *result;
@property (nonatomic, strong) Measurement *measurement;

@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *networkAsnLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryLabel;
@property (nonatomic, strong) IBOutlet UILabel *countryDetailLabel;
@property (nonatomic, strong) IBOutlet UILabel *runtimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *runtimeDetailLabel;
@property (nonatomic, strong) IBOutlet UIButton *dataButton;
@property (nonatomic, strong) IBOutlet UIButton *explorerButton;
@property (nonatomic, strong) IBOutlet UIButton *logButton;
@property (nonatomic, strong) IBOutlet RHMarkdownLabel *methodologyLabel;

@end
