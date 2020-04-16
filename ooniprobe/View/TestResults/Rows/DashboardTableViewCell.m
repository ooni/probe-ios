#import "DashboardTableViewCell.h"

@implementation DashboardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBorders];
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
    [self setBackgroundColor:[UIColor colorWithRGBHexString:color_white alpha:1.0f]];
    
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
    [self.cardbackgroundView setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow0 alpha:1.0f]];
}

-(void)setBorders{
    //self.cardbackgroundView.layer.cornerRadius = 15;
    //self.cardbackgroundView.layer.masksToBounds = YES;
    //https://medium.com/@serdaraylanc/adding-shadow-and-rounded-corner-to-uiview-ced57aa1b4c3
    //https://stackoverflow.com/questions/17502082/ios-how-to-add-drop-shadow-and-stroke-shadow-on-uiview
    self.cardbackgroundView.layer.shadowRadius  = 1.5f;
    self.cardbackgroundView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.cardbackgroundView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.cardbackgroundView.layer.shadowOpacity = 0.9f;
    self.cardbackgroundView.layer.masksToBounds = NO;

    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.cardbackgroundView.bounds, shadowInsets)];
    //UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.cardbackgroundView.bounds cornerRadius:self.cardbackgroundView.layer.cornerRadius];
    self.cardbackgroundView.layer.shadowPath = shadowPath.CGPath;
    
    //self.cardbackgroundView.layer.shadowPath = UIBezierPath(roundedRect: self.myView.bounds, cornerRadius: self.myView.layer.cornerRadius).cgPath
    /*
    self.cardbackgroundView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.cardbackgroundView.layer.shadowOpacity = 0.5;
    self.cardbackgroundView.layer.shadowOffset = CGSizeMake(10, 10);
    self.cardbackgroundView.layer.shadowRadius = 1;
    self.cardbackgroundView.layer.masksToBounds = false;
     */
    /*
    self.cardbackgroundView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.cardbackgroundView.layer.shadowOpacity = 1;
    self.cardbackgroundView.layer.shadowOffset = CGSizeZero;
    self.cardbackgroundView.layer.shadowRadius = 10;
    */
}

@end
