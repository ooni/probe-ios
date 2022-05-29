#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"

@interface WebsitesDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, strong) IBOutlet RHMarkdownLabel *textLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *uploadBarFooterConstraint;

@end
