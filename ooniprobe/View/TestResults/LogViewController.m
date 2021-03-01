#import "LogViewController.h"
#import "TestUtility.h"
#import "MessageUtility.h"
#import "MBProgressHUD.h"
#import "OONIApi.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                            initWithTitle:NSLocalizedString(@"TestResults.Details.CopyToClipboard", nil)
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(copy_clipboard:)];
    [self.textView setText:NSLocalizedString(@"OONIBrowser.Loading", nil)];
    if ([self.type isEqualToString:@"log"]){
        [self showLog];
    }
    else if ([self.type isEqualToString:@"json"]){
        [self showJson];
    }
    else if ([self.type isEqualToString:@"upload_log"]){
        [self showUploadLog];
    }

    [self.textView setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    self.textView.scrollEnabled = false;
    [self.textView layoutIfNeeded];
    self.textView.scrollEnabled = true;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [CountlyUtility recordView:@"DataView"];
}

- (void)showLog{
    NSString *fileName = [self.measurement getLogFile];
    self.text = [TestUtility getUTF8FileContent:fileName];
    if (self.text != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView setText:self.text];
        });
    }
    else {
        //Show Log not found alert, go back on OK.
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error.LogNotFound", nil)
                               message:nil
                              okButton:okButton
                          cancelButton:nil
                                inView:self];
    }
}

- (void)showJson{
    NSString *fileName = [self.measurement getReportFile];
    NSString *content = [TestUtility getUTF8FileContent:fileName];
    if (content != nil) {
        self.text = [self prettyPrintedJsonfromUTF8String:content];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView setText:self.text];
        });
    }
    else {
        //Download content from web
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        });
        [self.measurement getExplorerUrl:^(NSString *measurement_url){
            [OONIApi downloadJson:measurement_url
                            onSuccess:^(NSDictionary *measurementJson) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                                    self.text = [self prettyPrintedJsonfromObject:measurementJson];
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.textView setText:self.text];
                                    });
                                });
                            } onError:^(NSError *error) {
                                [self onError:error];
                            }];
        } onError:^(NSError *error){
            [self onError:error];
        }];
    }
}

- (void)showUploadLog{
    if (self.text != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView setText:self.text];
        });
    }
}

/*
 Probably we can remove prettyPrintedJsonfromString and
 prettyPrintedJsonfromObject them since we'll rewrite the json viewer in react
 */
/**
 This function gets a string and if it's a valid JSON makes it pretty printed
 */
-(NSString*)prettyPrintedJsonfromUTF8String:(NSString *)content{
    NSError *error;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error != nil) return content;
    NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
            options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return content;
    NSString *prettyPrintedJson = [NSString stringWithUTF8String:[prettyJsonData bytes]];
    return prettyPrintedJson;
}

/**
 This function gets JSON object and make it into a pretty printed string
 */
-(NSString*)prettyPrintedJsonfromObject:(id)jsonObject{
    NSError *error;
    NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
            options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return jsonObject;
    NSString *prettyPrintedJson = [NSString stringWithUTF8String:[prettyJsonData bytes]];
    return prettyPrintedJson;
}

-(void)onError:(NSError*)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    });
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.OK", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error", nil)
                           message:[error localizedDescription]
                          okButton:okButton
                      cancelButton:nil
                            inView:self];
}

-(IBAction)copy_clipboard:(id)sender{
    if (self.text != nil && [self.text isKindOfClass:[NSString class]]){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.text;
        [MessageUtility showToast:NSLocalizedString(@"Toast.CopiedToClipboard", nil) inView:self.view];
    }
}

@end
