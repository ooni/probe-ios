#import "TorTarget.h"

@implementation TorTarget

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.name = dictionary[@"name"];
        self.address = dictionary[@"address"];
        self.type = dictionary[@"type"];
        self.handshake = dictionary[@"handshake"];
        self.connect = dictionary[@"connect"];
    }
    return self;
}

+ (NSArray*)getTargetsFromArray:(NSArray*)curTargets{
    NSMutableArray *targets = [NSMutableArray new];
    for (NSDictionary *curTarget in curTargets){
        [targets addObject:[[TorTarget alloc] initWithDictionary:curTarget]];
    }
    return targets;
}

+ (NSArray*)getTargetsFromDic:(NSDictionary*)curTargets{
    NSMutableArray *targets = [NSMutableArray new];
    for (id key in curTargets){
        NSDictionary *curTarget = [curTargets objectForKey:key];
        TorTarget *target = [TorTarget new];
        target.name = [curTarget objectForKey:@"target_name"];
        target.address = [curTarget objectForKey:@"target_address"];
        target.type = [curTarget objectForKey:@"target_protocol"];
        NSDictionary *summary = [curTarget objectForKey:@"summary"];
        if (summary != nil){
            NSDictionary *handshake = [summary objectForKey:@"handshake"];
            NSDictionary *connect = [summary objectForKey:@"connect"];
            if (handshake != nil && [handshake objectForKey:@"failure"])
                target.handshake = [connect objectForKey:@"failure"];
            if (connect != nil && [connect objectForKey:@"failure"])
                target.connect = [connect objectForKey:@"failure"];
        }
        [targets addObject:target];
    }
    return targets;
}

@end
