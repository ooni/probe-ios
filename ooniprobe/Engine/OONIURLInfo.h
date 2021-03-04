#import <Foundation/Foundation.h>
#import <oonimkall/Oonimkall.h>

@interface OONIURLInfo : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *category_code;
@property (nonatomic, strong) NSString *country_code;

- (id) initWithURLInfo:(OonimkallURLInfo*)urlInfo;

@end
