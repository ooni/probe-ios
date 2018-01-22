#import "Article.h"

@implementation Article

-(NSString *)getTitle {
    return self.fields[@"title"];
}
@end
