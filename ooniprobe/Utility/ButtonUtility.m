#import "ButtonUtility.h"

@implementation ButtonUtility

+ (void)roundCorners:(UIButton*)button{
    [[button layer] setCornerRadius:3];
    [button setClipsToBounds:YES];
}

@end
