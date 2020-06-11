#import <Foundation/Foundation.h>

@interface TorTarget : NSObject
- (id)initWithDictionary:(NSDictionary*)dictionary;
+ (NSArray*)getTargetsFromArray:(NSArray*)curTargets;
+ (NSArray*)getTargetsFromDic:(NSDictionary*)targets;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *connect;
@property (nonatomic, strong) NSString *handshake;
@end
