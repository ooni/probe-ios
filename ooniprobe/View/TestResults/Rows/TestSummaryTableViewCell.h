#import <UIKit/UIKit.h>
#import "Result.h"
#import "Measurement.h"

@interface TestSummaryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (strong, nonatomic) IBOutlet UIImageView *notUploadedImage;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UIImageView *detail1Image;
@property (strong, nonatomic) IBOutlet UILabel *detail1Label;
@property (strong, nonatomic) IBOutlet UIStackView *stackView1;
@property (strong, nonatomic) IBOutlet UIStackView *stackView2;
@property (strong, nonatomic) IBOutlet UIImageView *detail2Image;
@property (strong, nonatomic) IBOutlet UILabel *detail2Label;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ndtSpaceConstraint;

-(void)setResult:(Result*)result andMeasurement:(Measurement*)measurement;
@end
