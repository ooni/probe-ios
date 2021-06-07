#import <Foundation/Foundation.h>
#import "OONIMKTask.h"
#import "OONIMKTaskConfig.h"
#import "PEMKTask.h"
#import "OONIContext.h"
#import "OONISession.h"
#import "OONISessionConfig.h"
#import "PESession.h"
#import "OONILogger.h"
#import "LoggerComposed.h"
#import "LoggeriOS.h"
#import "LoggerNull.h"
#import "LoggerArray.h"

/**
* Engine is a factory class for creating several kinds of tasks. We will use different
* engines depending on the task that you wish to create.
*/
@interface Engine : NSObject

+ (NSString*) newUUID4;

+ (PEMKTask*) startExperimentTaskWithSettings:(id<OONIMKTaskConfig>)settings error:(NSError **)error;

+ (PESession*) newSession:(OONISessionConfig*)config error:(NSError **)error;

+ (OONISessionConfig*) getDefaultSessionConfigWithSoftwareName:(NSString*)softwareName
                                               softwareVersion:(NSString*)softwareVersion
                                                        logger:(id<OONILogger>)logger;

+ (NSString*) getAssetsDir;

+ (NSString*) getStateDir;

+ (NSString*) getTempDir;

+ (NSString*) getTunnelDir;

@end
