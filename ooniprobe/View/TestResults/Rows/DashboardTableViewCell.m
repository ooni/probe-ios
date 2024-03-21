#import "DashboardTableViewCell.h"
#import "TestDescriptor.h"

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

-(void)setTestSuite:(TestDescriptor*)testSuite{
    [self.titleLabel setText:testSuite.name];
    [self.descLabel setText:testSuite.short_description];
    if (!testSuite.enabled) {
        [self.titleLabel setTextColor:[UIColor colorNamed:@"disabled_test_text"]];
        [self.descLabel setTextColor:[UIColor colorNamed:@"disabled_test_text"]];
        [self.testLogo setImage:[self imageWithGradient:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testSuite.icon]] startColor:[UIColor colorNamed:@"disabled_test_text"] endColor:[UIColor colorNamed:@"disabled_test_text"]]];
        [self.cardbackgroundView setBackgroundColor:[UIColor colorNamed:@"disabled_test_background"]];
    } else {
        [self.titleLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.descLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.testLogo setImage:[self imageWithGradient:[UIImage imageNamed:[NSString stringWithFormat:@"%@", testSuite.icon]] startColor:[TestUtility getGradientColorForTest:testSuite.icon] endColor:[TestUtility getColorForTest:testSuite.icon]]];
        [self.cardbackgroundView setBackgroundColor:[UIColor colorNamed:@"color_gray0"]];
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
-(UIImage *)imageWithGradient:(UIImage *)img startColor:(UIColor *)color1 endColor:(UIColor *)color2 {
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);

    // Create gradient
    NSArray *colors = [NSArray arrayWithObjects:(id)color2.CGColor, (id)color1.CGColor, nil];
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, NULL);

    // Apply gradient
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0, img.size.height), 0);
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);

    return gradientImage;
}
@end
