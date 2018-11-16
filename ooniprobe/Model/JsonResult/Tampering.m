#import "Tampering.h"

@implementation Tampering

-(id)initWithValue:(id)currentValue{
    self = [super init];
    if(self)
    {
        if ([currentValue isKindOfClass:[NSDictionary class]]){
            //currentValue is NSDictionary
            self.value = NO;
            NSDictionary *dic = (NSDictionary*)currentValue;
            NSDictionary *tampering = [dic objectForKey:@"tampering"];
            NSArray *chcekKeys = [[NSArray alloc]initWithObjects:@"header_field_name", @"header_field_number", @"header_field_value", @"header_name_capitalization", @"request_line_capitalization", @"total", nil];
            for (NSString *key in chcekKeys) {
                if ([tampering objectForKey:key] &&
                    [tampering objectForKey:key] != [NSNull null] &&
                    [[tampering objectForKey:key] boolValue]) {
                    self.value = YES;
                }
            }
        }
        else {
            //currentValue is Boolean
            BOOL value = [currentValue boolValue];
            self.value = value;
        }
    }
    return self;
}

@end
