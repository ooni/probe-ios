#import "TestDescriptor.h"

@implementation TestDescriptor

@dynamic runId,
name,
nameIntl,
shortDescription,
shortDescriptionIntl,
iDescription,
descriptionIntl,
author,
icon,
archived,
autoRun,
autoUpdate,
creationTime,
translationCreationTime,
nettests;

- (id)initWithDescriptorResponse:(DescriptorResponse *)response {
    self = [super init];
    if (self) {
        self.name = response.descriptor.name;
        self.nameIntl = response.descriptor.nameIntl;
        self.shortDescription = response.descriptor.shortDescription;
        self.shortDescriptionIntl = response.descriptor.shortDescriptionIntl;
        self.iDescription = response.descriptor.iDescription;
        self.descriptionIntl = response.descriptor.descriptionIntl;
        self.author = response.descriptor.author;
        self.icon = response.descriptor.icon;
        //self.archived = response.archived;
        self.autoRun = false;
        self.autoUpdate = false;
        self.creationTime = response.descriptorCreationTime;
        self.translationCreationTime = response.translationCreationTime;
        NSMutableArray<NSDictionary *> *dictionaryArray = [NSMutableArray array];

        for (Nettest *nettest in response.descriptor.nettests) {
            NSDictionary *dictionary = @{
                    @"test_name": nettest.testName,
                    @"inputs": nettest.inputs,
                    // Add more key-value pairs for other properties as needed
            };
            [dictionaryArray addObject:dictionary];
        }
        self.nettests = dictionaryArray;
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
        nettest.testName = dictionary[@"test_name"];
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
