#import <SharkORM/SharkORM.h>
#import "DescriptorResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestDescriptor : SRKObject

@property NSString *runId;

@property NSString *name;

@property NSString *shortDescription;

@property NSString *iDescription;

@property NSString *author;

@property NSArray<NSDictionary *> *nettests;

@property NSDictionary *nameIntl;

@property NSDictionary *shortDescriptionIntl;

@property NSDictionary *descriptionIntl;

@property NSString *icon;

@property NSString *color;

@property NSString *animation;

@property NSDate *expirationDate;

@property NSDate *dateCreated;

@property NSDate *dateUpdated;

@property NSString *revision;

@property bool isExpired;

@property bool isAutoRun;

@property bool isAutoUpdate;

- (id)initWithDescriptorResponse:(OONIRunDescriptor *)response;

- (NSArray<Nettest *> *)getNettests;

+ (NSArray *)uniquePropertiesForClass;

@end

NS_ASSUME_NONNULL_END
