#import "TestDescriptorManager.h"
#import "TestDescriptor.h"
#import "VersionUtility.h"
#import "PESession.h"
#import "Engine.h"

@implementation TestDescriptorManager
+ (void)fetchDescriptorFromRunId:(long)runId onSuccess:(void (^)(TestDescriptor *))successcb onError:(void (^)(NSError *))errorcb {
    NSError *error;

    PESession *session = [[PESession alloc] initWithConfig:
                    [Engine getDefaultSessionConfigWithSoftwareName:SOFTWARE_NAME
                                                    softwareVersion:[VersionUtility get_software_version]
                                                             logger:[LoggerArray new]]
                                                     error:&error];
    if (error != nil) {
        errorcb(error);
    }
    @try {
        DescriptorResponse *responseData = [session
                ooniRunFetch:session.newContext
                          id:runId
                       error:&error];

        if (error != nil) {
            errorcb(error);
        }

        TestDescriptor *testDescriptor = [[TestDescriptor alloc] initWithDescriptorResponse:responseData];
        testDescriptor.runId = runId;
        [testDescriptor commit];
        successcb(testDescriptor);

    } @catch (NSException *exception) {
        errorcb([NSError errorWithDomain:@"TestDescriptorManager"
                                    code:1
                                userInfo:@{@"exception": exception}]);
    }

}

+ (NSArray *)getTestObjects {
    return  [TestDescriptor.query fetch];
}


@end
