#import <SharkORM/SharkORM.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestDescriptor : SRKObject
@property NSString *name;
@property NSDictionary *nameIntl;
@property NSString *shortDescription;
@property NSDictionary *shortDescriptionIntl;
@property NSString *iDescription;
@property NSDictionary *descriptionIntl;
@property NSString *author;
@property NSString *icon;
@property bool archived;
@property bool autoRun;
@property bool autoUpdate;
@property NSDate *creationTime;
@property NSDate *translationCreationTime;
@property NSArray<NSDictionary *> *nettests;
@end

NS_ASSUME_NONNULL_END
