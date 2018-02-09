#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>

@interface Result : NSObject

@property NSInteger Id;
@property NSString *name;
@property NSDate *startTime;
@property NSDate *endTime;
@property NSInteger dataUsageDown;
@property NSInteger dataUsageUp;

//The json of the result is a summary that contains just a few kbs vs MBs of the report file
@property NSString *summary;
/*
 WebCensorship Json
 number of sites + blocked?
 
 Performance Json
 video streaming quality
 upload
 download
 ping
 
 IM Json
 -
 
 MiddleBox Json
 
 */
@property BOOL done;

-(id)init;
-(void)save;

@end
