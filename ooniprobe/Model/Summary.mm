#import "Summary.h"

@implementation Summary

-(id)init
{
    self = [super init];
    if(self)
    {
        self.json = [[NSMutableDictionary alloc] init];
        [self initVars];
    }
    return self;
}

- (id)initFromJson:(NSString*)json{
    self = [super init];
    if(self)
    {
        //string - to - NSDictionary
        NSError *error;
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        self.json = [[NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:&error] mutableCopy] ;
        if (error){
            NSLog(@"%@",[error description]);
            self.json = [[NSMutableDictionary alloc] init];
        }
        [self initVars];
    }
    return self;
}

- (void)initVars{
    if ([self.json safeObjectForKey:@"stats"]){
        self.totalMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"total"] integerValue];
        self.okMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"ok"] integerValue];
        self.failedMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"failed"] integerValue];
        self.blockedMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"blocked"] integerValue];
    }
    else {
        self.totalMeasurements = 0;
        self.okMeasurements = 0;
        self.failedMeasurements = 0;
        self.blockedMeasurements = 0;
    }
}

//TODO what to do when a test is re-run?
- (void)setStats {
    NSMutableDictionary *stats = [[NSMutableDictionary alloc] init];
    [stats setObject:[NSNumber numberWithInteger:self.totalMeasurements] forKey:@"total"];
    [stats setObject:[NSNumber numberWithInteger:self.okMeasurements] forKey:@"ok"];
    [stats setObject:[NSNumber numberWithInteger:self.failedMeasurements] forKey:@"failed"];
    [stats setObject:[NSNumber numberWithInteger:self.blockedMeasurements] forKey:@"blocked"];
    [self.json setObject:stats forKey:@"stats"];
}

- (NSString*)getJsonStr{
    [self setStats];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.json
                                                       options:0
                                                         error:&error];
    if (error){
        NSLog(@"%@",[error description]);
        return @"";
    }
    //Nsdictionary - to - string
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


- (NSString*)getUpload{
    if ([self.json safeObjectForKey:@"ndt"]){
        float upload = [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"upload"] floatValue];
        return [self setFractionalDigits:[self getScaledValue:upload]];
    }
    return NSLocalizedString(@"n_a", nil);
}

-(NSString*)getUploadUnit{
    if ([self.json safeObjectForKey:@"ndt"]){
        float upload = [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"upload"] floatValue];
        return [self getUnit:upload];
    }
    return NSLocalizedString(@"n_a", nil);
}

-(NSString*)getUploadWithUnit{
    NSString *uploadUnit = [self getUploadUnit];
    if (![uploadUnit isEqualToString:@"N/A"])
        return [NSString stringWithFormat:@"%@ %@", [self getUpload], uploadUnit];
    return NSLocalizedString(@"n_a", nil);
}

- (NSString*)getDownload{
    if ([self.json safeObjectForKey:@"ndt"]){
        float download = [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"download"] floatValue];
        return [self setFractionalDigits:[self getScaledValue:download]];
    }
    return NSLocalizedString(@"n_a", nil);
}

-(NSString*)getDownloadUnit{
    if ([self.json safeObjectForKey:@"ndt"]){
        float download = [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"download"] floatValue];
        return [self getUnit:download];
    }
    return NSLocalizedString(@"n_a", nil);
}

-(NSString*)getDownloadWithUnit{
    NSString *downloadUnit = [self getDownloadUnit];
    if (![downloadUnit isEqualToString:@"N/A"])
        return [NSString stringWithFormat:@"%@ %@", [self getDownload], downloadUnit];
    return NSLocalizedString(@"n_a", nil);
}

- (float)getScaledValue:(float)value{
    if (value < 100)
        return value;
    else if (value < 100000)
        return value/1000;
    else
        return value/1000000;
}

- (NSString*)setFractionalDigits:(float)value{
    if (value < 10)
        return [NSString stringWithFormat:@"%.2f", value];
    else
        return [NSString stringWithFormat:@"%.1f", value];
}

- (NSString*)getUnit:(float)value{
    //We assume there is no Tbit/s (for now!)
    if (value < 100)
        return @"kbit/s";
    else if (value < 100000)
        return @"Mbit/s";
    else
        return @"Gbit/s";
}

- (NSString*)getPing{
    if ([self.json safeObjectForKey:@"ndt"])
        return [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"ping"] stringValue];
    //TODO localize all N/A
    return NSLocalizedString(@"n_a", nil);
}

/*
 {\"ndt\":{\"upload\":14372.1621726751,\"download\":7500.1648334420097,\"ping\":33},\"dash\":{\"connect_latency\":0.0374929904937744,\"median_bitrate\":1549,\"min_playout_delay\":0.64208292961120605}}
 */

- (NSString*)getVideoQuality:(BOOL)shortened{
    if ([self.json safeObjectForKey:@"dash"]){
        if (shortened)
            return [self minimumShortBitrateForVideo:[[[self.json safeObjectForKey:@"dash"] safeObjectForKey:@"median_bitrate"] floatValue]];
        else
            return [self minimumBitrateForVideo:[[[self.json safeObjectForKey:@"dash"] safeObjectForKey:@"median_bitrate"] floatValue]];
    }
    return NSLocalizedString(@"n_a", nil);
}

- (NSString*)minimumBitrateForVideo:(float)videoQuality{
    if (videoQuality < 600)
        return @"240p";
    else if (videoQuality < 1000)
        return @"360p";
    else if (videoQuality < 2500)
        return @"480p";
    else if (videoQuality < 5000)
        return @"720p (HD)";
    else if (videoQuality < 8000)
        return @"1080p (full HD)";
    else if (videoQuality < 16000)
        return @"1440p (2k)";
    else
        return @"2160p (4k)";
}

- (NSString*)minimumShortBitrateForVideo:(float)videoQuality{
    if (videoQuality < 600)
        return @"240p";
    else if (videoQuality < 1000)
        return @"360p";
    else if (videoQuality < 2500)
        return @"480p";
    else if (videoQuality < 5000)
        return @"720p";
    else if (videoQuality < 8000)
        return @"1080p";
    else if (videoQuality < 16000)
        return @"1440p";
    else
        return @"2160p";
}

@end
