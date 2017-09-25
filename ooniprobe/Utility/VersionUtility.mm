#import "VersionUtility.h"

@implementation VersionUtility

+ (NSString*)get_software_version{
    return [NSString stringWithFormat:@"%@%@+%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], release_name, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}
@end
