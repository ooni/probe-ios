#import <UIKit/UIKit.h>
#import "TestDetailsViewController.h"
#import "PaddingLabel.h"

@interface MiddleBoxesDetailsViewController : TestDetailsViewController

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *subtitleLabel;

@property (nonatomic, strong) IBOutlet UIStackView *sentReceivedStackView;

@property (nonatomic, strong) IBOutlet UILabel *sentTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *receivedTitleLabel;

@property (nonatomic, strong) IBOutlet PaddingLabel *sent1Label;
@property (nonatomic, strong) IBOutlet PaddingLabel *received1Label;

@property (nonatomic, strong) IBOutlet PaddingLabel *sent2Label;
@property (nonatomic, strong) IBOutlet PaddingLabel *received2Label;

@property (nonatomic, strong) IBOutlet PaddingLabel *sent3Label;
@property (nonatomic, strong) IBOutlet PaddingLabel *received3Label;

@property (nonatomic, strong) IBOutlet PaddingLabel *sent4Label;
@property (nonatomic, strong) IBOutlet PaddingLabel *received4Label;

- (void)setLabelValue:(NSArray*)arr :(int)idx :(int)column;
@end
