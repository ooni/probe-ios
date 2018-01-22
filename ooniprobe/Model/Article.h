#import <Foundation/Foundation.h>
#import <ContentfulDeliveryAPI/ContentfulDeliveryAPI.h>

@interface Article : CDAEntry

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *authors;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *tags;
@property (strong, nonatomic) NSString *publicationDate;
@property (strong, nonatomic) NSString *content;

- (NSString *)getTitle;
@end
