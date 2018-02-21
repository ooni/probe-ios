#import <UIKit/UIKit.h>
#import "Result.h"

@interface TestResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *testIcon;
@property (strong, nonatomic) IBOutlet UILabel *testNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *testAsnLabel;
@property (strong, nonatomic) IBOutlet UILabel *testTimeLabel;
@property (strong, nonatomic) IBOutlet UIStackView *mainStackView;
@property (strong, nonatomic) IBOutlet UIStackView *stackView1;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UIStackView *stackView2;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UIStackView *stackView3;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UILabel *label3;

-(void)setResult:(Result*)result;
@end
