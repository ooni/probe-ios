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
        //TODO show some Log not found
    }
    else if ([self.type isEqualToString:@"json"]){
        fileName = [self.measurement getReportFile];
        NSString *content = [TestUtility getUTF8FileContent:fileName];
        if (content != nil) {
            NSString *prettyPrintedJson = [self prettyPrintedJson:content];
            [self.textView setText:prettyPrintedJson];
        }
        else {
            //TODO Download content from web
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
