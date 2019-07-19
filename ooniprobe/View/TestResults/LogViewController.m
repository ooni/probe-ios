#import "LogViewController.h"
#import "TestUtility.h"
#import "MessageUtility.h"

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
    if ([self.type isEqualToString:@"log"]){
        NSString *fileName = [self.measurement getLogFile];
        NSString *content = [TestUtility getUTF8FileContent:fileName];
        if (content != nil) {
            [self.textView setText:content];
        }
        else {
            //Show Log not found alert, go back on OK.
            //This will be useful for when we'll implement the auto log deletion
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
    else if ([self.type isEqualToString:@"json"]){
        NSString *fileName = [self.measurement getReportFile];
        NSString *content = [TestUtility getUTF8FileContent:fileName];
        if (content != nil) {
            NSString *prettyPrintedJson = [self prettyPrintedJsonfromString:content];
            [self.textView setText:prettyPrintedJson];
        }
        else {
            //Download content from web
            [self.measurement getExplorerUrl:^(NSString *measurement_url){
                [TestUtility downloadJson:measurement_url
                                onSuccess:^(NSDictionary *measurementJson) {
                                    NSString *prettyPrintedJson = [self prettyPrintedJsonfromObject:measurementJson];
                                    [self.textView setText:prettyPrintedJson];
                                } onError:^(NSError *error) {
                                    [self onError:error];
                                }];
            } onError:^(NSError *error){
                [self onError:error];
            }];
        }
    }
    [self.textView setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    self.textView.scrollEnabled = false;
    [self.textView layoutIfNeeded];
    self.textView.scrollEnabled = true;
}

/*
 Probably we can remove prettyPrintedJsonfromString and
 prettyPrintedJsonfromObject them since we'll rewrite the json viewer in react
 */
/*
 This function gets a string and if it's a valid JSON makes it pretty printed
 */
-(NSString*)prettyPrintedJsonfromString:(NSString *)content{
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

/*
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
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
    [MessageUtility showToast:NSLocalizedString(@"Toast.CopiedToClipboard", nil) inView:self.view];
}

@end
