#import "VersionUtility.h"

@implementation VersionUtility

+ (NSString*)get_software_version{
    // FIXME: this breaks OONI backend so we don't send the build number
    /*
    return [NSString stringWithFormat:@"%@%@+%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], RELEASE_NAME, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
     */
    return [NSString stringWithFormat:@"%@%@",
            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
            RELEASE_NAME];

}
@end
