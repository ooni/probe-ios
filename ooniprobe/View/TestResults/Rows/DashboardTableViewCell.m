#import "DashboardTableViewCell.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [UIView
            animateWithDuration:0.3f
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                self.contentView.alpha = 0.7f;
            }
            completion: NULL
         ];
    } else {
        [UIView
         animateWithDuration:0.8f
         delay:0.5f
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             self.contentView.alpha = 1.f;
         }
         completion: NULL
        ];
    }
}

-(void)setTestSuite:(AbstractSuite*)testSuite{
    [self setBackgroundColor:[UIColor colorWithRGBHexString:color_gray1 alpha:1.0f]];
    
    [self.runButton setTitleColor:[TestUtility getColorForTest:testSuite.name] forState:UIControlStateNormal];
    [self.runButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Dashboard.Card.Run", nil)] forState:UIControlStateNormal];
    
    [self.titleLabel setText:[LocalizationUtility getNameForTest:testSuite.name]];
    [self.descLabel setText:[LocalizationUtility getDescriptionForTest:testSuite.name]];
    //TODO convert seconds to minutes and hours when needed
    //if getRuntime = 0 show one hour
    int runTime = [testSuite getRuntime];
    if (runTime == 0)
        runTime = 3600;
    NSString *time = NSLocalizedFormatString(@"Dashboard.Card.Seconds", [NSString stringWithFormat:@"%d", runTime]);
    [self.estimateTime setText:time];
    [self.bottomLabel setText:NSLocalizedString(@"Dashboard.Card.Subtitle", nil)];
    
    [self.testLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testSuite.name]]];
    [self.testLogo setTintColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    [self.cardbackgroundView setBackgroundColor:[TestUtility getColorForTest:testSuite.name]];
    self.cardbackgroundView.layer.cornerRadius = 15;
    self.cardbackgroundView.layer.masksToBounds = YES;
}

@end
