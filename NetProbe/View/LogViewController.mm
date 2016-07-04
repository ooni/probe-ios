//
//  LogViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 10/03/15.
//  Copyright (c) 2015 Simone Basso. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.test.json_file];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]) {
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSMutableString *prettyJson = [[NSMutableString alloc] init];
        NSArray *separateJson = [content componentsSeparatedByString:@"\n"];
        for (NSString* json in separateJson)
            if([json length] > 0)
                [prettyJson appendFormat:@"%@\n", [self prettyJson:json]];
        [self.logView setText:prettyJson];
    }
}

-(NSString*)prettyJson:(NSString*)jsonString{
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (jsonObject){
        NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
        NSString *prettyPrintedJson = [[NSString alloc] initWithData:prettyJsonData encoding:NSUTF8StringEncoding];
        return prettyPrintedJson;
    }
    return @"";
}

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
