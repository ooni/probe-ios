#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"

@interface DashDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *bitrateTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bitrateValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *bitrateUnitLabel;

@property (nonatomic, strong) IBOutlet UILabel *delayTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *delayValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *delayUnitLabel;

@end
