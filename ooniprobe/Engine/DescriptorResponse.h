#import <Foundation/Foundation.h>

@class DescriptorResponse;
@class Descriptor;
@class Nettest;


NS_ASSUME_NONNULL_BEGIN

@interface DescriptorResponse : NSObject

@property (nonatomic, assign) NSInteger archived;
@property (nonatomic, strong) Descriptor *descriptor;
@property (nonatomic, copy)   NSDate *descriptorCreationTime;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, copy)   NSDate *translationCreationTime;
@property (nonatomic, assign) NSInteger v;

@end


@interface Descriptor : NSObject
@property (nonatomic, copy)   NSString *author;
@property (nonatomic, copy)   NSString *iDescription;
@property (nonatomic, weak)   NSDictionary *descriptionIntl;
@property (nonatomic, copy)   NSString *icon;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, weak)   NSDictionary *nameIntl;
@property (nonatomic, copy)   NSArray<Nettest *> *nettests;
@property (nonatomic, copy)   NSString *shortDescription;
@property (nonatomic, weak)   NSDictionary *shortDescriptionIntl;
@end


@interface Nettest : NSObject
@property (nonatomic, weak)   NSDictionary *backendOptions;
@property (nonatomic, copy)   NSArray<NSString *> *inputs;
@property (nonatomic, assign) BOOL isBackgroundRunEnabled;
@property (nonatomic, assign) BOOL isManualRunEnabled;
@property (nonatomic, weak)   NSDictionary *options;
@property (nonatomic, copy)   NSString *testName;
@end

NS_ASSUME_NONNULL_END
