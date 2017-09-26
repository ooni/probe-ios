#import "RoundedButton.h"

@implementation RoundedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    //UIColor *defaultTintColor = color_ooni_blue;
    //self.layer.borderWidth = 1;
    //self.layer.borderColor = defaultTintColor.CGColor;
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
