#import "Engine.h"
#import <mkall/MKVersion.h>
#define probeEngineTasks @[@"Telegram", @"Ndt", @"Dash", @"Psiphon", @"Tor", @"Whatsapp", @"FacebookMessenger", @"HttpHeaderFieldManipulation", @"HttpInvalidRequestLine"]

@implementation Engine

/** getVersionMK returns the version of Measurement Kit we're using */
+ (NSString*) versionMK {
    return [MKVersion versionMK];
}

/** startExperimentTask starts the experiment described by the provided settings. */
+ (id<ExperimentTask>) startExperimentTaskWithSettings:(id<ExperimentSettings>)settings error:(NSError **)error {
    if ([probeEngineTasks containsObject:settings.taskName]) {
        return [[OONIProbeEngineTaskAdapter alloc]
                initWithTask:OonimkallStartTask([settings serialization], error)];
    }
    return [[MKExperimentTaskAdapter alloc]
            initWithTask:[MKAsyncTask start:settings.dictionary]];
}

/** newGeoIPLookupTask creates a new GeoIP lookup task. */
+ (id<GeoIPLookupTask>) geoIPLookupTask {
    return [[MKGeoIPLookupTaskAdapter alloc] init];
}

/** newCollectorTask creates a new collector task. */
+ (id<CollectorTask>) collectorTaskWithSoftwareName:(NSString *)softwareName
                                   softwareVersion:(NSString *)softwareVersion {
    return [[MKReporterTaskAdapter alloc] initWithSoftwareName:softwareName
                                               softwareVersion:softwareVersion];
}

@end
