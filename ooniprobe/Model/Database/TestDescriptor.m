#import "TestDescriptor.h"
#import "DescriptorResponse.h"

@implementation TestDescriptor

@dynamic runId,
name ,
shortDescription,
iDescription,
author,
nettests,
nameIntl,
shortDescriptionIntl,
descriptionIntl,
icon,
color,
animation,
expirationDate,
dateCreated,
dateUpdated,
revision,
isExpired,
isAutoRun,
isAutoUpdate;


- (nonnull id)initWithDescriptorResponse:(nonnull OONIRunDescriptor *)response {
    
    self = [super init];
    if (self) {
        
        self.runId = response.oonirun_link_id;
        self.name = response.name;
        self.shortDescription = response.short_description;
        self.iDescription = response.i_description;
        self.author = response.author;
        
        NSMutableArray<NSDictionary *> *dictionaryArray = [NSMutableArray array];
        
        for (Nettest *nettest in response.nettests) {
            NSDictionary *dictionary = @{
                @"test_name": nettest.test_name,
                @"inputs": nettest.inputs,
                // Add more key-value pairs for other properties as needed
            };
            [dictionaryArray addObject:dictionary];
        }
        self.nettests = dictionaryArray;
        
        self.nameIntl = response.name_intl;
        self.shortDescriptionIntl = response.short_description_intl;
        self.descriptionIntl = response.description_intl;
        self.icon = response.icon;
        self.color = response.color;
        self.animation = response.animation;
        self.expirationDate = response.expiration_date;
        self.dateCreated = response.date_created;
        self.dateUpdated = response.date_updated;
        self.revision = response.revision;
        self.isExpired = response.is_expired;
        
        self.isAutoRun = false;
        self.isAutoUpdate = false;
        self.dateCreated = response.date_created;
    }
    return self;
}


/**
 * Get the nettests from the descriptor
 * @return NSArray<Nettest *> *nettests
 */
- (NSArray<Nettest *> *)getNettests {
    NSMutableArray<Nettest *> *nettests = [NSMutableArray array];
    for (NSDictionary *dictionary in self.nettests) {
        Nettest *nettest = [[Nettest alloc] init];
        nettest.test_name = dictionary[@"test_name"];
        nettest.inputs = dictionary[@"inputs"];
        // Add more key-value pairs for other properties as needed
        [nettests addObject:nettest];
    }
    return nettests;
}

+ (NSArray *)uniquePropertiesForClass {
    return @[@"runId"];
}

@end
