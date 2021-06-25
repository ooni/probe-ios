#import "RunningTest.h"

@implementation RunningTest

static RunningTest *currentTest = nil;

+ (RunningTest *) currentTest
{
    @synchronized(self)
    {
        if (currentTest == nil)
        {
            currentTest = [[RunningTest alloc] init];
        }
    }
    return currentTest;
}

@end
