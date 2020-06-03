#import "Engine.h"
#define probeEngineTasks @[@"Telegram", @"Dash", @"Ndt"]

@implementation Engine

/** getVersionMK returns the version of Measurement Kit we're using */
+ (NSString*) getVersionMK {
    return [MKVersion versionMK];
}

/** startExperimentTask starts the experiment described by the provided settings. */
/*
 + (id<ExperimentTask>) startExperimentTask(ExperimentSettings settings) throws EngineException {
    if (probeEngineTasks.contains(settings.taskName())) {
        try {
            return new OONIProbeEngineTaskAdapter(
                    oonimkall.Oonimkall.startTask(settings.serialization())
            );
        } catch (Exception exc) {
            throw new EngineException("cannot start OONI Probe Engine task", exc);
        }
    }
    return new MKExperimentTaskAdapter(io.ooni.mk.MKAsyncTask.start(settings.serialization()));
}*/
//MKAsyncTask *task = [MKAsyncTask start:settings];


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
