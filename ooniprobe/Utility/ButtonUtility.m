// Part of MeasurementKit <https://measurement-kit.github.io/>.
// MeasurementKit is free software. See AUTHORS and LICENSE for more
// information on the copying conditions.

#import "ButtonUtility.h"

@implementation ButtonUtility

+ (void)roundCorners:(UIButton*)button{
    [[button layer] setCornerRadius:3];
    [button setClipsToBounds:YES];
}

@end
