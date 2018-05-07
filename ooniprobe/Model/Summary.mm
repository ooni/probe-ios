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
        self.totalMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"total"] intValue];
        self.okMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"ok"] intValue];
        self.failedMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"failed"] intValue];
        self.blockedMeasurements = [[[self.json safeObjectForKey:@"stats"] objectForKey:@"blocked"] intValue];
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

- (NSDictionary*)getDicForTest:(NSString*)test{
    if ([self.json safeObjectForKey:test])
        return [self.json safeObjectForKey:test];
    return nil;
}

#pragma mark Websites
- (NSString*)getBlocking:(NSString*)input{
    NSDictionary *dic = [self getDicForTest:input];
    NSLog(@"dic %@", dic);
    if (dic){
        NSString *blocking = [NSString stringWithFormat:@"%@", [dic safeObjectForKey:@"blocking"]];
        if ([blocking isEqualToString:@"dns"])
            return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.DNS", nil);
        else if ([blocking isEqualToString:@"tcp_ip"])
            return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.TCPIP", nil);
        else if ([blocking isEqualToString:@"http-diff"])
            return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.HTTPDiff", nil);
        //TODO missing strings
        else if ([blocking isEqualToString:@"http-failure"])
            return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.HTTPDiff", nil);
        //TODO return generic string
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

#pragma mark NDT

- (NSString*)getUpload{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        float upload = [[dic safeObjectForKey:@"upload"] floatValue];
        return [self setFractionalDigits:[self getScaledValue:upload]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

-(NSString*)getUploadUnit{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        float upload = [[dic safeObjectForKey:@"upload"] floatValue];
        return [self getUnit:upload];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

-(NSString*)getUploadWithUnit{
    NSString *uploadUnit = [self getUploadUnit];
    if (![uploadUnit isEqualToString:@"N/A"])
        return [NSString stringWithFormat:@"%@ %@", [self getUpload], uploadUnit];
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getDownload{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        float download = [[dic safeObjectForKey:@"download"] floatValue];
        return [self setFractionalDigits:[self getScaledValue:download]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

-(NSString*)getDownloadUnit{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        float download = [[dic safeObjectForKey:@"download"] floatValue];
        return [self getUnit:download];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

-(NSString*)getDownloadWithUnit{
    NSString *downloadUnit = [self getDownloadUnit];
    if (![downloadUnit isEqualToString:@"N/A"])
        return [NSString stringWithFormat:@"%@ %@", [self getDownload], downloadUnit];
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
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
        return NSLocalizedString(@"TestResults.Kbps", nil);
    else if (value < 100000)
        return NSLocalizedString(@"TestResults.Mbps", nil);
    else
        return NSLocalizedString(@"TestResults.Gbps", nil);
}

- (NSString*)getPing{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        return [NSString stringWithFormat:@"%.1f", [[dic safeObjectForKey:@"ping"] floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}


- (NSString*)getServer {
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        //TODO add fallback
        return [NSString stringWithFormat:@"%@ - %@", [dic safeObjectForKey:@"server_name"], [dic safeObjectForKey:@"server_country"]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getPacketLoss{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        float pl = [[dic safeObjectForKey:@"packet_loss"] floatValue]*100;
        return [NSString stringWithFormat:@"%.3f", pl];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getOutOfOrder{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        float ooo = [[dic safeObjectForKey:@"out_of_order"] floatValue]*100;
        return [NSString stringWithFormat:@"%.1f", ooo];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getAveragePing{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        return [NSString stringWithFormat:@"%.1f", [[dic safeObjectForKey:@"avg_rtt"] floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getMaxPing{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        return [NSString stringWithFormat:@"%.1f", [[dic safeObjectForKey:@"max_rtt"] floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getMSS{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        return [NSString stringWithFormat:@"%@", [dic safeObjectForKey:@"mss"]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getTimeouts{
    NSDictionary *dic = [self getDicForTest:@"ndt"];
    if (dic){
        return [NSString stringWithFormat:@"%@", [dic safeObjectForKey:@"timeouts"]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

#pragma mark Dash

- (NSString*)getMedianBitrate{
    NSDictionary *dic = [self getDicForTest:@"dash"];
    if (dic){
        float mb = [[dic safeObjectForKey:@"median_bitrate"] floatValue];
        return [self setFractionalDigits:[self getScaledValue:mb]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

-(NSString*)getMedianBitrateUnit{
    NSDictionary *dic = [self getDicForTest:@"dash"];
    if (dic){
        float mb = [[dic safeObjectForKey:@"median_bitrate"] floatValue];
        return [self getUnit:mb];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)getVideoQuality:(BOOL)extended{
    NSDictionary *dic = [self getDicForTest:@"dash"];
    if (dic){
        return [self minimumBitrateForVideo:[[dic safeObjectForKey:@"median_bitrate"] floatValue] extended:extended];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (NSString*)minimumBitrateForVideo:(float)videoQuality extended:(BOOL)extended{
    if (videoQuality < 600)
        return @"240p";
    else if (videoQuality < 1000)
        return @"360p";
    else if (videoQuality < 2500)
        return @"480p";
    else if (videoQuality < 5000)
        return (extended) ? @"720p (HD)" : @"720p";
    else if (videoQuality < 8000)
        return (extended) ? @"1080p (full HD)" : @"1080p";
    else if (videoQuality < 16000)
        return (extended) ? @"1440p (2k)" : @"1440p";
    else
        return (extended) ? @"2160p (4k)" : @"2160p";
}

- (NSString*)getPlayoutDelay{
    NSDictionary *dic = [self getDicForTest:@"dash"];
    if (dic){
        return [NSString stringWithFormat:@"%.2f", [[dic safeObjectForKey:@"min_playout_delay"] floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

#pragma mark HIRL

- (NSArray*)getSent{
    NSDictionary *dic = [self getDicForTest:@"http_invalid_request_line"];
    if (dic){
        NSArray *sent = [dic safeObjectForKey:@"sent"];
        return sent;
    }
    return nil;
}

- (NSArray*)getReceived{
    NSDictionary *dic = [self getDicForTest:@"http_invalid_request_line"];
    if (dic){
        NSArray *received = [dic safeObjectForKey:@"received"];
        return received;
    }
    return nil;
}


@end
