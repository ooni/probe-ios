#import "ProxySettings.h"

@implementation ProxySettings

- (id) init {
    self = [super init];
    if (self) {
        NSString *protocol = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_protocol"];
        if ([protocol isEqualToString:[ProxySettings getProtocol:NONE]]) {
            self.protocol = NONE;
        } else if ([protocol isEqualToString:[ProxySettings getProtocol:PSIPHON]]) {
            self.protocol = PSIPHON;
        } else if ([protocol isEqualToString:[ProxySettings getProtocol:SOCKS5]]) {
            self.protocol = SOCKS5;
        } else if ([protocol isEqualToString:[ProxySettings getProtocol:HTTP]]) {
            self.protocol = HTTP;
        } else if ([protocol isEqualToString:[ProxySettings getProtocol:HTTPS]]) {
            self.protocol = HTTPS;
        } else {
            // This is where we will extend the code to add support for
            // more proxies, e.g., HTTP proxies.
        }
        self.hostname = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_hostname"];
        self.port = [[NSUserDefaults standardUserDefaults] objectForKey:@"proxy_port"];
    }
    return self;
}

- (void)saveProxy{
    [[NSUserDefaults standardUserDefaults] setObject:[ProxySettings getProtocol:self.protocol] forKey:@"proxy_protocol"];
    [[NSUserDefaults standardUserDefaults] setObject:self.hostname forKey:@"proxy_hostname"];
    [[NSUserDefaults standardUserDefaults] setObject:self.port forKey:@"proxy_port"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isCustom{
    if (self.protocol == SOCKS5 || self.protocol == HTTP || self.protocol == HTTPS)
        return true;
    return false;
}

- (NSString*)getProxyString{
    if (self.protocol == NONE)
        return @"";
    if (self.protocol == PSIPHON)
        return @"psiphon://";
    if (self.protocol == SOCKS5) {
        // Alright, we now need to construct a new SOCKS5 URL.
        NSString *urlStr = [NSString stringWithFormat:@"socks5://%@:%@/", self.hostname, self.port];
        if ([ProxySettings isIPv6:self.hostname]) {
            urlStr = [NSString stringWithFormat:@"socks5://[%@]:%@/", self.hostname, self.port]; // IPv6 must be quoted in URLs
        }
        return urlStr;
    }
    if (self.protocol == HTTP) {
        // Alright, we now need to construct a new HTTP URL.
        NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/", self.hostname, self.port];
        if ([ProxySettings isIPv6:self.hostname]) {
            urlStr = [NSString stringWithFormat:@"http://[%@]:%@/", self.hostname, self.port]; // IPv6 must be quoted in URLs
        }
        return urlStr;
    }
    if (self.protocol == HTTPS) {
        // Alright, we now need to construct a new HTTPS URL.
        NSString *urlStr = [NSString stringWithFormat:@"https://%@:%@/", self.hostname, self.port];
        if ([ProxySettings isIPv6:self.hostname]) {
            urlStr = [NSString stringWithFormat:@"https://[%@]:%@/", self.hostname, self.port]; // IPv6 must be quoted in URLs
        }
        return urlStr;
    }
    if (self.protocol == HTTP) {
        // Alright, we now need to construct a new SOCKS5 URL.
        NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/", self.hostname, self.port];
        if ([ProxySettings isIPv6:self.hostname]) {
            urlStr = [NSString stringWithFormat:@"http://[%@]:%@/", self.hostname, self.port]; // IPv6 must be quoted in URLs
        }
        //URI url = new URI(urlStr);
        return urlStr;
    }
    if (self.protocol == HTTPS) {
        // Alright, we now need to construct a new SOCKS5 URL.
        NSString *urlStr = [NSString stringWithFormat:@"https://%@:%@/", self.hostname, self.port];
        if ([ProxySettings isIPv6:self.hostname]) {
            urlStr = [NSString stringWithFormat:@"https://[%@]:%@/", self.hostname, self.port]; // IPv6 must be quoted in URLs
        }
        //URI url = new URI(urlStr);
        return urlStr;
    }
    return @"";

}

+ (BOOL)isIPv6:(NSString*)hostname{
    if ([hostname containsString:@"::"])
        return true;
    return false;
}

+ (NSString*)getProtocol:(ProxyProtocol) protocol {
    NSString *result = nil;
    switch(protocol) {
        case NONE:
            result = @"proxy_none";
            break;
        case PSIPHON:
            result = @"proxy_psiphon";
            break;
        case SOCKS5:
            result = @"socks5";
            break;
        case HTTP:
            result = @"http";
            break;
        case HTTPS:
            result = @"https";
            break;
        default:
            result = @"unknown";
    }
    return result;
}
@end
