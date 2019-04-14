#import "TestKeys.h"
#import "JsonResult.h"

@implementation TestKeys

- (NSString*)getJsonStr{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self dictionary]
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

#pragma mark Websites
- (NSString*)getWebsiteBlocking{
    if (self.blocking != nil){
        NSString *blocking = [NSString stringWithFormat:@"%@", self.blocking];
        if ([blocking isEqualToString:@"dns"])
        return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.DNS", nil);
        else if ([blocking isEqualToString:@"tcp_ip"])
        return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.TCPIP", nil);
        else if ([blocking isEqualToString:@"http-diff"])
        return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.HTTPDiff", nil);
        else if ([blocking isEqualToString:@"http-failure"])
        return NSLocalizedString(@"TestResults.Details.Websites.LikelyBlocked.BlockingReason.HTTPFailure", nil);
        return NSLocalizedString(@"TestResults.NotAvailable", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
#pragma mark WHATSAPP
    
- (NSString*)getWhatsappEndpointStatus {
    if (self.whatsapp_endpoints_status != nil){
        NSString* endpointStatus = self.whatsapp_endpoints_status;
        if ([endpointStatus isEqualToString:BLOCKED])
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Failed", nil);
        else
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Application.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getWhatsappWebStatus {
    if (self.whatsapp_web_status != nil){
        NSString* webStatus = self.whatsapp_web_status;
        if ([webStatus isEqualToString:BLOCKED])
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.WebApp.Label.Failed", nil);
        else
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.WebApp.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getWhatsappRegistrationStatus {
    if (self.registration_server_status != nil){
        NSString* registrationStatus = self.registration_server_status;
        if ([registrationStatus isEqualToString:BLOCKED])
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Failed", nil);
        else
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (UIColor*)getWhatsappEndpointStatusColor {
    if (self.whatsapp_endpoints_status != nil){
        NSString* endpointStatus = self.whatsapp_endpoints_status;
        if ([endpointStatus isEqualToString:BLOCKED])
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

- (UIColor*)getWhatsappWebStatusColor {
    if (self.whatsapp_web_status != nil){
        NSString* webStatus = self.whatsapp_web_status;
        if ([webStatus isEqualToString:BLOCKED])
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

- (UIColor*)getWhatsappRegistrationStatusColor {
    if (self.registration_server_status != nil){
        NSString* registrationStatus = self.registration_server_status;
        if ([registrationStatus isEqualToString:BLOCKED])
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

#pragma mark TELEGRAM
    
- (NSString*)getTelegramEndpointStatus {
    if (self.telegram_http_blocking != nil && self.telegram_tcp_blocking != nil){
        BOOL httpBlocking = [self.telegram_http_blocking boolValue];
        BOOL tcpBlocking = [self.telegram_tcp_blocking boolValue];
        if (httpBlocking || tcpBlocking)
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Failed", nil);
        else
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.Application.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getTelegramWebStatus {
    if (self.telegram_web_status != nil){
        NSString* registrationStatus = self.telegram_web_status;
        if ([registrationStatus isEqualToString:BLOCKED])
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Failed", nil);
        else
            return NSLocalizedString(@"TestResults.Details.InstantMessaging.Telegram.WebApp.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (UIColor*)getTelegramEndpointStatusColor {
    if (self.telegram_http_blocking != nil && self.telegram_tcp_blocking != nil){
        BOOL httpBlocking = [self.telegram_http_blocking boolValue];
        BOOL tcpBlocking = [self.telegram_tcp_blocking boolValue];
        if (httpBlocking || tcpBlocking)
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

- (UIColor*)getTelegramWebStatusColor {
    if (self.telegram_web_status != nil){
        NSString* registrationStatus = self.telegram_web_status;
        if ([registrationStatus isEqualToString:BLOCKED])
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

#pragma mark FB
    
- (NSString*)getFacebookMessengerDns {
    if (self.facebook_dns_blocking){
        BOOL dnsBlocking = [self.facebook_dns_blocking boolValue];
        if (dnsBlocking)
        return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Failed", nil);
        else
        return NSLocalizedString(@"TestResults.Details.InstantMessaging.WhatsApp.Registrations.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getFacebookMessengerTcp {
    if (self.facebook_tcp_blocking != nil){
        BOOL tcpBlocking = [self.facebook_tcp_blocking boolValue];
        if (tcpBlocking)
        return NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.TCP.Label.Failed", nil);
        else
        return NSLocalizedString(@"TestResults.Details.InstantMessaging.FacebookMessenger.TCP.Label.Okay", nil);
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

- (UIColor*)getFacebookMessengerDnsColor {
    if (self.facebook_dns_blocking){
        BOOL dnsBlocking = [self.facebook_dns_blocking boolValue];
        if (dnsBlocking)
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

- (UIColor*)getFacebookMessengerTcpColor {
    if (self.facebook_tcp_blocking != nil){
        BOOL tcpBlocking = [self.facebook_tcp_blocking boolValue];
        if (tcpBlocking)
            return [UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f];
        else
            return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
    }
    return [UIColor colorWithRGBHexString:color_gray9 alpha:1.0f];
}

#pragma mark NDT
    
- (NSString*)getUpload{
    if (self.simple.upload != nil){
        float upload = [self.simple.upload floatValue];
        return [self setFractionalDigits:[self getScaledValue:upload]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
-(NSString*)getUploadUnit{
    if (self.simple.upload != nil){
        float upload = [self.simple.upload floatValue];
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
    if (self.simple.download != nil){
        float download = [self.simple.download floatValue];
        return [self setFractionalDigits:[self getScaledValue:download]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
-(NSString*)getDownloadUnit{
    if (self.simple.download != nil){
        float download = [self.simple.download floatValue];
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
    if (value < 1000)
    return value;
    else if (value < 1000*1000)
    return value/1000;
    else
    return value/1000*1000;
}
    
- (NSString*)setFractionalDigits:(float)value{
    if (value < 10)
    return [NSString stringWithFormat:@"%.2f", value];
    else
    return [NSString stringWithFormat:@"%.1f", value];
}
    
- (NSString*)getUnit:(float)value{
    //We assume there is no Tbit/s (for now!)
    if (value < 1000)
    return NSLocalizedString(@"TestResults.Kbps", nil);
    else if (value < 1000*1000)
    return NSLocalizedString(@"TestResults.Mbps", nil);
    else
    return NSLocalizedString(@"TestResults.Gbps", nil);
}
    
- (NSString*)getPing{
    if (self.simple.ping != nil){
        return [NSString stringWithFormat:@"%.1f", [self.simple.ping floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
    
- (NSString*)getServer {
    if (self.server_name != nil && self.server_country != nil){
        return [NSString stringWithFormat:@"%@ - %@", self.server_name, self.server_country];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getPacketLoss{
    if (self.advanced.packet_loss != nil){
        float pl = [self.advanced.packet_loss floatValue]*100;
        return [NSString stringWithFormat:@"%.3f", pl];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getOutOfOrder{
    if (self.advanced.out_of_order != nil){
        float ooo = [self.advanced.out_of_order floatValue]*100;
        return [NSString stringWithFormat:@"%.1f", ooo];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getAveragePing{
    if (self.advanced.avg_rtt != nil){
        return [NSString stringWithFormat:@"%.1f", [self.advanced.avg_rtt floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getMaxPing{
    if (self.advanced.max_rtt != nil){
        return [NSString stringWithFormat:@"%.1f", [self.advanced.max_rtt floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getMSS{
    if (self.advanced.mss != nil){
        return [NSString stringWithFormat:@"%d", [self.advanced.mss intValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getTimeouts{
    if (self.advanced.timeouts != nil){
        return [NSString stringWithFormat:@"%d", [self.advanced.timeouts intValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
#pragma mark Dash
    
- (NSString*)getMedianBitrate{
    if (self.simple.median_bitrate != nil){
        float mb = [self.simple.median_bitrate floatValue];
        return [self setFractionalDigits:[self getScaledValue:mb]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
-(NSString*)getMedianBitrateUnit{
    if (self.simple.median_bitrate != nil){
        float mb = [self.simple.median_bitrate floatValue];
        return [self getUnit:mb];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}
    
- (NSString*)getVideoQuality:(BOOL)extended{
    if (self.simple.median_bitrate != nil){
        return [self minimumBitrateForVideo:[self.simple.median_bitrate floatValue] extended:extended];
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
    if (self.simple.min_playout_delay != nil){
        return [NSString stringWithFormat:@"%.2f", [self.simple.min_playout_delay floatValue]];
    }
    return NSLocalizedString(@"TestResults.NotAvailable", nil);
}

@end
