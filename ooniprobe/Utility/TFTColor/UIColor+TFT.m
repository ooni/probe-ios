//
//  UIColor+TFT.m
//  Color
//
//  Created by Burhanuddin Sunelwala on 11/18/14.
//  Copyright (c) 2014 TFT. All rights reserved.
//

#import "UIColor+TFT.h"

CGFloat const MAX_VAL = 255.0f;
NSString *const HEX_CHAR_SET = @"abcdefABCDEF1234567890";

@implementation UIColor (TFT)

#pragma mark - Helper Methods
+ (NSString *)cleanHexString:(NSString *)hexString expectedLength:(int)expectedLength {
    
    NSMutableString *mutableHexString = [hexString mutableCopy];
    if ([hexString hasPrefix:@"#"]) {
        
        [mutableHexString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    else if ([hexString hasPrefix:@"0x"] ||
               [hexString hasPrefix:@"0X"]) {
        
        [mutableHexString deleteCharactersInRange:NSMakeRange(0, 2)];
    }
    
    //Check for Special Characters. Truncate the string from first special character.
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:HEX_CHAR_SET] invertedSet];
    NSUInteger firstInvalidChar = [hexString rangeOfCharacterFromSet:characterSet].location;
    if (firstInvalidChar != NSNotFound) {
        
        [mutableHexString deleteCharactersInRange:NSMakeRange(firstInvalidChar, mutableHexString.length - firstInvalidChar)];
    }
    
    //Repeat each hex digit if length is half
    if (mutableHexString.length == expectedLength/2) {
        
        for (int i = 0; i < expectedLength/2; ++i) {
            
            [mutableHexString insertString:[mutableHexString  substringWithRange:NSMakeRange(i*2, 1)] atIndex:i*2];
        }
    }
    //Append zeros if the length is less than the expected length
    else if (mutableHexString.length < expectedLength) {
        
        while (mutableHexString.length != expectedLength) {
            [mutableHexString insertString:@"0" atIndex:0];
        }
    }
    //Truncate the excess string if length is greater than expected length
    else if(mutableHexString.length > expectedLength) {
        
        [mutableHexString deleteCharactersInRange:NSMakeRange(expectedLength, hexString.length - expectedLength)];
    }
    return mutableHexString;
}

+ (NSUInteger)hexValueFromHexString:(NSString *)hexString {
    
    unsigned hexValue = 0;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hexValue];
    return hexValue;
}

+ (NSArray *)rgbComponentsForColor:(UIColor *)color {
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSArray *colorComponents = @[@(red), @(green), @(blue)];
    return colorComponents;
}

#pragma mark - Public Methods

#pragma mark RGB
+ (UIColor *)colorWithRGBHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    
    NSString *cleanedHexString = [UIColor cleanHexString:hexString expectedLength:6];
    return [UIColor colorWithRGBHexValue:[self hexValueFromHexString:cleanedHexString] alpha:alpha];
}

+ (UIColor *)colorWithRGBHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha {

    return [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f
                           green:(((hexValue & 0xFF00) >> 8))/255.0f
                            blue:((hexValue & 0xFF))/255.0f alpha:1.0f];
}

+ (NSString *)rgbHexStringForColor:(UIColor *)color {

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];

    NSMutableString *hexString = [NSMutableString string];
    [hexString appendFormat:@"%02x", (int)(red * 255)];
    [hexString appendFormat:@"%02x", (int)(green * 255)];
    [hexString appendFormat:@"%02x", (int)(blue * 255)];
    
    return hexString;
}

+ (NSUInteger)rgbHexValueForColor:(UIColor *)color {
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    
    NSUInteger hexValue = (NSUInteger)(red * 255) << 16;
    hexValue |= (NSUInteger)(green * 255) << 8;
    hexValue |= (NSUInteger)(blue * 255);

    return hexValue;
}

#pragma mark CNYK
+ (UIColor *)colorWithCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow black:(CGFloat)black alpha:(CGFloat)alpha {
    
    CGFloat red = (1.0f - cyan) * (1.0f - black);
    CGFloat green = (1.0f - magenta) * (1.0f - black);
    CGFloat blue = (1.0f - yellow) * (1.0f - black);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)getCyan:(CGFloat *)cyan magenta:(CGFloat *)magenta yellow:(CGFloat *)yellow black:(CGFloat *)black alpha:(CGFloat *)alpha {
    
    CGFloat *red;
    CGFloat *green;
    CGFloat *blue;
    [self getRed:red green:green blue:blue alpha:alpha];
    
    *black = 1.0f - MAX(MAX(*red, *blue), *green);
    *cyan = (1.0f - *red - *black) / (1.0f - *black);
    *magenta = (1.0f - *green - *black) / (1.0f - *black);
    *yellow = (1.0f - *blue - *black) / (1.0f - *black);
}

@end