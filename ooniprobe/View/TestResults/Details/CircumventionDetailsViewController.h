#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"
#import "RHMarkdownLabel.h"

@interface CircumventionDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet RHMarkdownLabel *textLabel;

@property (nonatomic, strong) IBOutlet UILabel *detail1TitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detail1SubtitleLabel;

@property (nonatomic, strong) IBOutlet UILabel *detail2TitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detail2SubtitleLabel;

@end
