#import <Foundation/Foundation.h>
#import <SharkORM/SharkORM.h>

@interface Result : SRKObject

//@property NSInteger Id;
@property NSString *name;
@property NSDate *startTime;
@property NSDate *endTime;
@property NSInteger dataUsageDown;
@property NSInteger dataUsageUp;
@property NSString *ip;
@property NSString *asn;
@property NSString *asnName;
@property NSString *country;
@property NSString *networkName;
@property NSString *networkType;

//The json of the result is a summary that contains just a few kbs vs MBs of the report file
@property NSString *summary;
/*
 WebCensorship Json
 number of sites + blocked + anomalies
 
 Performance Json
 video streaming quality
 upload
 download
 ping
 
 IM Json
 number tested
 number blocked
 
 MiddleBox Json
 found/not found
 */
@property BOOL done;

-(void)save;
-(SRKResultSet*)measurements;
@end
