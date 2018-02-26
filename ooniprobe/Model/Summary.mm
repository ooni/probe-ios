#import "Summary.h"

@implementation Summary

-(id)init
{
    self = [super init];
    if(self)
    {
        self.json = [[NSMutableDictionary alloc] init];
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
        self.json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
        if (error){
            NSLog(@"%@",[error description]);
            self.json = [[NSMutableDictionary alloc] init];
        }
        else
            NSLog(@"%@",json);
    }
    return self;
}

- (NSString*)getJsonStr{
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
    if ([self.json safeObjectForKey:@"ndt"])
        return [NSString stringWithFormat:@"%.0f", [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"upload"] floatValue]];
    return @"";
}

- (NSString*)getDownload{
    if ([self.json safeObjectForKey:@"ndt"])
        return [NSString stringWithFormat:@"%.0f", [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"download"] floatValue]];
    return @"";
}

- (NSString*)getPing{
    if ([self.json safeObjectForKey:@"ndt"])
        return [[[self.json safeObjectForKey:@"ndt"] safeObjectForKey:@"ping"] stringValue];
    return @"";
}

/*
 {\"ndt\":{\"upload\":14372.1621726751,\"download\":7500.1648334420097,\"ping\":33},\"dash\":{\"connect_latency\":0.0374929904937744,\"median_bitrate\":1549,\"min_playout_delay\":0.64208292961120605}}
 */

- (NSString*)getVideoQuality{
    if ([self.json safeObjectForKey:@"dash"])
        return [self minimumBitrateForVideo:[[[self.json safeObjectForKey:@"dash"] safeObjectForKey:@"median_bitrate"] floatValue]];
    return @"";
}

- (NSString*)minimumBitrateForVideo:(float)videoQuality{
    //TODO localize?
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
@end
