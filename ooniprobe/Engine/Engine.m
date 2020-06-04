#import "Engine.h"
#define probeEngineTasks @[@"Telegram", @"Dash", @"Ndt"]

@implementation Engine

/** getVersionMK returns the version of Measurement Kit we're using */
+ (NSString*) getVersionMK {
    return [MKVersion versionMK];
}

/** startExperimentTask starts the experiment described by the provided settings. */
+ (id<ExperimentTask>) startExperimentTaskWithSettings:(id<ExperimentSettings>)settings {
    if ([probeEngineTasks containsObject:settings.taskName]) {
        NSError * err;
        OONIProbeEngineTaskAdapter *task = [[OONIProbeEngineTaskAdapter alloc]
                                            initWithTask:OonimkallStartTask(settings.serialization, &err)];
        if (!err)
            return task;
        NSLog(@"cannot start OONI Probe Engine task");
    }
    return [[MKExperimentTaskAdapter alloc]
            initWithTask:[MKAsyncTask start:settings.dictionary]];
}

/** newGeoIPLookupTask creates a new GeoIP lookup task. */
+ (id<GeoIPLookupTask>) getNewGeoIPLookupTask {
    return [[MKGeoIPLookupTaskAdapter alloc] init];
}

/** newCollectorTask creates a new collector task. */
+ (id<CollectorTask>) getNewCollectorTaskWithSoftwareName:(NSString *)softwareName
                                   softwareVersion:(NSString *)softwareVersion {
    return [[MKReporterTaskAdapter alloc] initWithSoftwareName:softwareName
                                               softwareVersion:softwareVersion];
}

/** newOrchestraTask creates a new orchestra task. */
+ (id<OrchestraTask>) getNewOrchestraTaskWithSoftwareName:(NSString *)softwareName
                                    softwareVersion:(NSString *)softwareVersion
                                     supportedTests:(NSArray<NSString *> *)supportedTests
                                        deviceToken:(NSString *)deviceToken
                                        secretsFile:(NSString *)secretsFile{
    return [[MKOrchestraTaskAdapter alloc] initWithSoftwareName:softwareName
                                                softwareVersion:softwareVersion
                                                 supportedTests:supportedTests
                                                    deviceToken:deviceToken
                                                    secretsFile:secretsFile];
}

@end
