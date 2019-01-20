#import "VersionUtility.h"

@implementation VersionUtility

+ (NSString*)get_software_version{
    return [NSString stringWithFormat:@"%@%@",
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
            RELEASE_NAME];

}
@end
