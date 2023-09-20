#import <Foundation/Foundation.h>

@class DescriptorResponse;
@class Descriptor;
@class Nettest;


NS_ASSUME_NONNULL_BEGIN

@interface DescriptorResponse : NSObject

@property (nonatomic, assign) NSInteger archived;
@property (nonatomic, strong) Descriptor *descriptor;
@property (nonatomic, copy)   NSDate *descriptor_creation_time;
@property (nonatomic, assign) BOOL is_mine;
@property (nonatomic, copy)   NSDate *translation_creation_time;
@property (nonatomic, assign) NSInteger v;

@end


@interface Descriptor : NSObject
@property (nonatomic, copy)   NSString *author;
@property (nonatomic, copy)   NSString *i_description;
@property (nonatomic, weak)   NSDictionary *description_intl;
@property (nonatomic, copy)   NSString *icon;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, weak)   NSDictionary *name_intl;
@property (nonatomic, copy)   NSArray<Nettest *> *nettests;
@property (nonatomic, copy)   NSString *short_description;
@property (nonatomic, weak)   NSDictionary *short_description_intl;
@end


@interface Nettest : NSObject
@property (nonatomic, weak)   NSDictionary *backend_options;
@property (nonatomic, copy)   NSArray<NSString *> *inputs;
@property (nonatomic, assign) BOOL is_background_run_enabled;
@property (nonatomic, assign) BOOL is_manual_run_enabled;
@property (nonatomic, weak)   NSDictionary *options;
@property (nonatomic, copy)   NSString *test_name;
@end

NS_ASSUME_NONNULL_END
