#include <sys/sysctl.h>
#import "UIDevice-DeviceInfo.h"

@implementation UIDevice (DeviceInfo)

- (NSString *)getSysInfoByName:(const char *)typeSpecifier
{
    size_t size = 0;
    int retsize = sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);

    if (retsize == 0 || size == 0){
        NSException* myException = [NSException
                                    exceptionWithName:@"ParseError"
                                    reason:@"Parse Error"
                                    userInfo:nil];
        @throw myException;
    }

    char *answer = malloc(size);
    if (answer == NULL) {
        NSException* myException = [NSException
                                    exceptionWithName:@"MallocError"
                                    reason:@"Malloc Error"
                                    userInfo:nil];
        @throw myException;
    }
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);

    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];

    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

@end
