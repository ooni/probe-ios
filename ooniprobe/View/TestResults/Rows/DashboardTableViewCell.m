#import "DashboardTableViewCell.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setRoundedView];
    [self setShadow];
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
                self.contentView.layer.shadowOpacity = 0;
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
             self.contentView.layer.shadowOpacity = 0.6f;
             self.contentView.alpha = 1.f;
         }
         completion: NULL
        ];
    }
}

-(void)setTestSuite:(AbstractSuite*)testSuite{
    /*[self.runButton setTitleColor:[TestUtility getColorForTest:testSuite.name] forState:UIControlStateNormal];
    [self.runButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Dashboard.Card.Run", nil)] forState:UIControlStateNormal];
    */
    [self.titleLabel setText:[LocalizationUtility getNameForTest:testSuite.name]];
    [self.descLabel setText:[LocalizationUtility getDescriptionForTest:testSuite.name]];
    /*[self.estimateTime setText:[LocalizationUtility getReadableRuntime:[testSuite getRuntime]]];
    [self.bottomLabel setText:NSLocalizedString(@"Dashboard.Card.Subtitle", nil)];
    */
    [self.testLogo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testSuite.name]]];
    [self.testLogo setTintColor:[TestUtility getColorForTest:testSuite.name]];
    [self.cardbackgroundView setBackgroundColor:[UIColor whiteColor]];
}

-(void)setRoundedView{
    self.cardbackgroundView.layer.cornerRadius = 5;
    self.cardbackgroundView.layer.masksToBounds = YES;
}

-(void)setShadow{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //https://medium.com/@serdaraylanc/adding-shadow-and-rounded-corner-to-uiview-ced57aa1b4c3
    //https://stackoverflow.com/questions/17502082/ios-how-to-add-drop-shadow-and-stroke-shadow-on-uiview
    self.contentView.layer.shadowRadius  = 5;
    self.contentView.layer.shadowColor   = [[UIColor blackColor] colorWithAlphaComponent:0.8f].CGColor;
    self.contentView.layer.shadowOffset  = CGSizeMake(0.0f, 1);
    self.contentView.layer.shadowOpacity = 0.6f;
    self.contentView.layer.masksToBounds = NO;
}

@end
