#import "Article.h"

@implementation Article

-(NSString *)title {
    return self.fields[@"title"];
}

-(NSArray *)authors {
    return self.fields[@"authors"];
}

-(NSArray *)images {
    return self.fields[@"images"];
}

-(NSArray *)tags {
    return self.fields[@"tags"];
}

-(NSString *)publicationDate {
    return self.fields[@"publicationDate"];
}

-(NSString *)content {
    return self.fields[@"content"];
}

@end
