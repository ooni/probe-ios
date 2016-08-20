//
//  ResultViewController.m
//  NetProbe
//
//  Created by Lorenzo Primiterra on 22/07/16.
//  Copyright © 2016 Simone Basso. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *items = [self getItems];
    if ([items count] > 1){
        UIBarButtonItem *chiudi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectTest)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:chiudi, nil];
    }
    [self loadScreen:[items objectAtIndex:0]];
}

-(void) loadScreen :(NSString*) content{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController* userController = [[WKUserContentController alloc] init];
    
    
    NSString* MeasurementJSON = [NSString stringWithFormat:@"\n var MeasurementJSON = {  \n"
                                 "get: function() {  \n"
                                 "return "
                                 //"'%@';"
                                 "%@;"
                                 "   } \n"
                                 "}", content];
    //NSLog(@"%@", MeasurementJSON);
    
    WKUserScript* userScript = [[WKUserScript alloc]initWithSource:MeasurementJSON
                                                     injectionTime: WKUserScriptInjectionTimeAtDocumentStart
                                                  forMainFrameOnly:NO];
    [userController addUserScript:userScript];
    configuration.userContentController = userController;
    
    NSString *pathToHtml = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *htmlData = [NSString stringWithContentsOfFile:pathToHtml encoding:NSUTF8StringEncoding error:NULL];

    CGRect frame = self.view.frame;
    
    //BUG FIX: when alloc the second time the webview goes under top bar
    if (self.webView != nil) {
        [self.webView removeFromSuperview];
        frame.origin.y +=64;
        frame.size.height -= 64;
    }
    
    self.webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
    [self.view addSubview:self.webView];
    [self.webView loadHTMLString:htmlData baseURL:[[NSBundle mainBundle] bundleURL]];
}

-(void) selectTest{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:NSLocalizedString(@"select_test", nil)
                                  delegate:self
                                  cancelButtonTitle:nil
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:nil];
    NSArray *tests = [self getItems];
    for(NSString *content in tests){
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"input %@", [json objectForKey:@"input"]]];
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.tag = 1;
    [actionSheet showInView:self.view];
}

-(NSArray*)getItems{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.json_file];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *content = @"";
    if([fileManager fileExistsAtPath:filePath]) {
        content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        //Cut out the last \n
        content = [content substringToIndex:[content length]-1];
    }
    return [content componentsSeparatedByString:@"\n"];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1){
        [self loadScreen:[[self getItems] objectAtIndex:buttonIndex]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
