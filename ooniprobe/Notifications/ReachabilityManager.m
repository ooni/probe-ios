#import "ReachabilityManager.h"

@implementation ReachabilityManager

+ (ReachabilityManager *)sharedManager {
    static ReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        // Initialize Reachability
        self.reachability = [Reachability reachabilityForInternetConnection];
        // Start Monitoring
        [self.reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
        
    }
    
    return self;
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    NSLog(@"reachabilityDidChange %@", notification);
    //Interrupt test if network changed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"interruptTest" object:nil];
}

- (NSString*)getStatus{
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    NSString *networkType;
    if (status == ReachableViaWiFi)
        networkType = @"wifi";
    else if (status == ReachableViaWWAN)
        networkType = @"mobile";
    else if(status == NotReachable)
        networkType = @"no_internet";
    return networkType;
}

- (BOOL)noInternetAccess{
    return ([[self getStatus] isEqualToString:@"no_internet"]);
}

- (BOOL)isWifi{
    return ([[self getStatus] isEqualToString:@"wifi"]);
}

- (BOOL)isVPNConnected {
    NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
    NSArray *keys = [dict[@"__SCOPED__"]allKeys];
    for (NSString *key in keys) {
        if ([key rangeOfString:@"tap"].location != NSNotFound ||
            [key rangeOfString:@"tun"].location != NSNotFound ||
            [key rangeOfString:@"ipsec"].location != NSNotFound ||
            [key rangeOfString:@"ppp"].location != NSNotFound){
            return YES;;
        }
    }
    return NO;
}

- (float)getBatteryLevel{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    float batteryLevel = [[UIDevice currentDevice] batteryLevel];
    //This will give you the battery between 0.0 (empty) and 1.0 (100% charged)
    //If you want it as a percentage, you can do this:
    batteryLevel *= 100;
    return batteryLevel;
}

@end
