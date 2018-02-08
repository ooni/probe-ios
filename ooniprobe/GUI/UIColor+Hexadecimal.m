#import "UIColor+Hexadecimal.h"

@implementation UIColor(Hexadecimal)

+ (UIColor *)colorWithRGBHexString:(NSString *)hexString alpha:(CGFloat)alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:(((rgbValue & 0xFF0000) >> 16))/255.0f
                           green:(((rgbValue & 0xFF00) >> 8))/255.0f
                            blue:((rgbValue & 0xFF))/255.0f alpha:alpha];
}

@end
