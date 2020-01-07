#import <UIKit/UIKit.h>
#import "TestUtility.h"
#import "RunButton.h"
#import "Suite.h"
#import "DateTools.h"

@interface DashboardTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cardbackgroundView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *estimateTime;
@property (strong, nonatomic) IBOutlet RunButton *runButton;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;
@property (strong, nonatomic) IBOutlet UIImageView *testLogo;

-(void)setTestSuite:(AbstractSuite*)testSuite;
@end
