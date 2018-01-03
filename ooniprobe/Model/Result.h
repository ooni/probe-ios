#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, assign) NSInteger uniqueId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

//The json of the result is a summary that contains just a few kbs vs MBs of the report file
@property (strong, nonatomic) NSString *json;
@property (nonatomic, assign) BOOL done;

-(id)init;
-(void)save;

@end
