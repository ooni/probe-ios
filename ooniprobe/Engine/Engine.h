#import <Foundation/Foundation.h>
#import "MKExperimentTaskAdapter.h"
#import "MKGeoIPLookupResultsAdapter.h"
#import "MKGeoIPLookupTaskAdapter.h"
#import "MKOrchestraResultsAdapter.h"
#import "MKOrchestraTaskAdapter.h"
#import "MKReporterResultsAdapter.h"
#import "MKReporterTaskAdapter.h"
#import "OONIProbeEngineTaskAdapter.h"
#import <mkall/MKVersion.h>
#import <mkall/MKGeoIPLookup.h>
#import <mkall/MKOrchestra.h>
#import <mkall/MKReporter.h>
#import <mkall/MKAsyncTask.h>

/**
* Engine is a factory class for creating several kinds of tasks. We will use different
* engines depending on the task that you wish to create.
*/
@interface Engine : NSObject

+ (NSString*) getVersionMK;

+ (id<GeoIPLookupTask>) getNewGeoIPLookupTask;

+ (id<CollectorTask>) getNewCollectorTaskWithSoftwareName:(NSString *)softwareName
                                     softwareVersion:(NSString *)softwareVersion;

+ (id<OrchestraTask>) getNewOrchestraTaskWithSoftwareName:(NSString *)softwareName
                                    softwareVersion:(NSString *)softwareVersion
                                     supportedTests:(NSArray<NSString *> *)supportedTests
                                        deviceToken:(NSString *)deviceToken
                                        secretsFile:(NSString *)secretsFile;
@end
