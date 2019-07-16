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
    NSString *fileName;
    if ([self.type isEqualToString:@"log"]){
        fileName = [self.measurement getLogFile];
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
            //TODO create a string for this, DO NOT MERGE WITHOUT
            [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.Error.LogNotFound", nil)
                                   message:nil
                                  okButton:okButton
                              cancelButton:nil
                                    inView:self];
        }
    }
    else if ([self.type isEqualToString:@"json"]){
        fileName = [self.measurement getReportFile];
        NSString *content = [TestUtility getUTF8FileContent:fileName];
        if (content != nil) {
            NSString *prettyPrintedJson = [self prettyPrintedJson:content];
            [self.textView setText:prettyPrintedJson];
        }
        else {
            //Download content from web
            [self.measurement getExplorerUrl:^(NSString *measurement_url){
                //TODO show measurement_url (in webview?)
            } onError:^(NSError *error){
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
            }];
        }
    }
    [self.textView setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    self.textView.scrollEnabled = false;
    [self.textView layoutIfNeeded];
    self.textView.scrollEnabled = true;
}

-(NSString*)prettyPrintedJson:(NSString *)content{
    NSError *error;
    NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error != nil) return content;
    NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) return content;
    NSString *prettyPrintedJson = [NSString stringWithUTF8String:[prettyJsonData bytes]];
    return prettyPrintedJson;
}

-(IBAction)copy_clipboard:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
    [MessageUtility showToast:NSLocalizedString(@"Toast.CopiedToClipboard", nil) inView:self.view];
}

@end
