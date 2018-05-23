#import "PaddingLabel.h"
#define padding UIEdgeInsetsMake(5, 10, 5, 10)

@implementation PaddingLabel
//From https://stackoverflow.com/a/34333687/1187692

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, padding)];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 8;
}

- (CGSize) intrinsicContentSize {
    CGSize superContentSize = [super intrinsicContentSize];
    CGFloat width = superContentSize.width + padding.left + padding.right;
    CGFloat height = superContentSize.height + padding.top + padding.bottom;
    return CGSizeMake(width, height);
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize superSizeThatFits = [super sizeThatFits:size];
    CGFloat width = superSizeThatFits.width + padding.left + padding.right;
    CGFloat height = superSizeThatFits.height + padding.top + padding.bottom;
    return CGSizeMake(width, height);
}
@end
