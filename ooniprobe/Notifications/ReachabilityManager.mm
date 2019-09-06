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
    NSString *networkType = [self getStatus];
    if (![networkType isEqualToString:@"no_internet"]){
        [NotificationService updateClient];
    }
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

- (BOOL)isInternetAccessible{
    return (![self getStatus] isEqualToString:@"no_internet"]);
}

@end
