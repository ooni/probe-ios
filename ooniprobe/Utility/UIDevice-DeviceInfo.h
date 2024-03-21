#import <UIKit/UIKit.h>

@interface UIDevice (DeviceInfo)

/**
 Returns a machine-readable model name in the format of "iPhone4,1"
 */
- (NSString *)modelIdentifier;

/**
 Returns a human readable model name in the format of "iPhone 4S"
 */
- (NSString *)modelName;

@end
