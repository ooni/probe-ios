#import <UIKit/UIKit.h>
#import <SharkORM/SharkORM.h>
#import "Result.h"
#import "Measurement.h"
#import "SettingsUtility.h"

@interface ResultsHeaderViewController : UIViewController {
    NSString *filter;
}

@property (strong, nonatomic) IBOutlet UILabel *testsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberTestsLabel;
@property (strong, nonatomic) IBOutlet UILabel *networksLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberNetworksLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataUsageLabel;
@property (strong, nonatomic) IBOutlet UILabel *upLabel;
@property (strong, nonatomic) IBOutlet UILabel *downLabel;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;

@end
