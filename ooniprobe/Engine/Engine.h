#import <Foundation/Foundation.h>
#import "ExperimentSettings.h"
#import "MKExperimentTaskAdapter.h"
#import "MKGeoIPLookupResultsAdapter.h"
#import "MKGeoIPLookupTaskAdapter.h"
#import "MKOrchestraResultsAdapter.h"
#import "MKOrchestraTaskAdapter.h"
#import "MKReporterResultsAdapter.h"
#import "MKReporterTaskAdapter.h"
#import "OONIProbeEngineTaskAdapter.h"

/**
* Engine is a factory class for creating several kinds of tasks. We will use different
* engines depending on the task that you wish to create.
*/
@interface Engine : NSObject

+ (NSString*) versionMK;

+ (id<ExperimentTask>) startExperimentTaskWithSettings:(id<ExperimentSettings>)settings error:(NSError*)error;

+ (id<GeoIPLookupTask>) geoIPLookupTask;

+ (id<CollectorTask>) collectorTaskWithSoftwareName:(NSString *)softwareName
                                     softwareVersion:(NSString *)softwareVersion;

+ (id<OrchestraTask>) orchestraTaskWithSoftwareName:(NSString *)softwareName
                                    softwareVersion:(NSString *)softwareVersion
                                     supportedTests:(NSArray<NSString *> *)supportedTests
                                        deviceToken:(NSString *)deviceToken
                                        secretsFile:(NSString *)secretsFile;
@end
