#include <sys/sysctl.h>
#import "UIDevice-DeviceInfo.h"

@implementation UIDevice (DeviceInfo)

- (NSString *)getSysInfoByName:(const char *)typeSpecifier
{
    size_t size = 0;
    int ret = sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    if (ret != 0 || size == 0) abort();

    char *answer = malloc(size);
    if (answer == NULL) abort();
    
    ret = sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    if (ret != 0) {
        free(answer);
        abort();
    }
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

@end
