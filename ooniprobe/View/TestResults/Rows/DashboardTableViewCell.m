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
    [self.titleLabel setText:[LocalizationUtility getNameForTest:testSuite.name]];
    [self.descLabel setText:[LocalizationUtility getDescriptionForTest:testSuite.name]];
    if (testSuite.getTestList.count <= 0) {
        [self.titleLabel setTextColor:[UIColor colorNamed:@"disabled_test_text"]];
        [self.descLabel setTextColor:[UIColor colorNamed:@"disabled_test_text"]];
        [self.testLogo setImage:[self imageWithGradient:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testSuite.name]] startColor:[UIColor colorNamed:@"disabled_test_text"] endColor:[UIColor colorNamed:@"disabled_test_text"]]];
        [self.cardbackgroundView setBackgroundColor:[UIColor colorNamed:@"disabled_test_background"]];
    } else {
        [self.titleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.descLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.testLogo setImage:[self imageWithGradient:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testSuite.name]] startColor:[TestUtility getGradientColorForTest:testSuite.name] endColor:[TestUtility getColorForTest:testSuite.name]]];
        [self.cardbackgroundView setBackgroundColor:[UIColor colorNamed:@"color_gray0"]];
    }

    if ([testSuite.name isEqualToString:@"ooni-run"]) {
        // cast testsuite to OONIRunSuite
        OONIRunSuite *ooniRunSuite = (OONIRunSuite *)testSuite;
        [self.titleLabel setText:ooniRunSuite.descriptor.name];
        [self.descLabel setText:ooniRunSuite.descriptor.shortDescription];
        [self.testLogo setImage:[self imageWithGradient:[UIImage imageNamed:@"about_ooni"] startColor:[UIColor colorNamed:@"color_gray6"] endColor:[UIColor colorNamed:@"color_gray6"]]];

    }
}

-(void)setRoundedView{
    self.cardbackgroundView.layer.cornerRadius = 5;
    self.cardbackgroundView.layer.masksToBounds = YES;
}

-(void)setShadow{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.contentView.layer.shadowRadius  = 5;
    self.contentView.layer.shadowColor   = [[UIColor blackColor] colorWithAlphaComponent:0.8f].CGColor;
    self.contentView.layer.shadowOffset  = CGSizeMake(0.0f, 1);
    self.contentView.layer.shadowOpacity = 0.6f;
    self.contentView.layer.masksToBounds = NO;
}

//From https://stackoverflow.com/questions/8098130/how-can-i-tint-a-uiimage-with-gradient
- (UIImage *)imageWithGradient:(UIImage *)img startColor:(UIColor *)color1 endColor:(UIColor *)color2 {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:img.size];

    UIImage *gradientImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextRef context = rendererContext.CGContext;
        CGContextTranslateCTM(context, 0, img.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);

        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);

        // Create gradient
        NSArray *colors = @[(id)color2.CGColor, (id)color1.CGColor];
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);

        // Apply gradient
        CGContextClipToMask(context, rect, img.CGImage);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0, img.size.height), 0);

        CGGradientRelease(gradient);
        CGColorSpaceRelease(space);
    }];

    return gradientImage;
}
@end
