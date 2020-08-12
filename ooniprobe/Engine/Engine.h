#import <Foundation/Foundation.h>
#import "ExperimentSettings.h"
#import "MKExperimentTaskAdapter.h"
#import "MKGeoIPLookupResultsAdapter.h"
#import "MKGeoIPLookupTaskAdapter.h"
#import "MKReporterResultsAdapter.h"
#import "MKReporterTaskAdapter.h"
#import "OONIProbeEngineTaskAdapter.h"

/**
* Engine is a factory class for creating several kinds of tasks. We will use different
* engines depending on the task that you wish to create.
*/
@interface Engine : NSObject

+ (NSString*) versionMK;

+ (NSString*) newUUID4;

+ (id<ExperimentTask>) startExperimentTaskWithSettings:(id<ExperimentSettings>)settings error:(NSError **)error;

+ (id<GeoIPLookupTask>) geoIPLookupTask;

+ (id<CollectorTask>) collectorTaskWithSoftwareName:(NSString *)softwareName
                                     softwareVersion:(NSString *)softwareVersion;
@end
