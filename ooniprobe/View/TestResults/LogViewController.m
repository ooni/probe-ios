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

    if ([self.type isEqualToString:@"log"] || [self.type isEqualToString:@"json"]){
        NSString *fileName;
        if ([self.type isEqualToString:@"log"])
            fileName = [self.measurement getLogFile];
        else if ([self.type isEqualToString:@"json"])
            fileName = [self.measurement getReportFile];
        NSString *content = [TestUtility getUTF8FileContent:fileName];
        if (content != nil) {
            if ([self.type isEqualToString:@"json"]){
                NSError *error;
                NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
                id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                if (error != nil) return;
                NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&error];
                if (error != nil) return;
                NSString *prettyPrintedJson = [NSString stringWithUTF8String:[prettyJsonData bytes]];
                [self.textView setText:prettyPrintedJson];
            }
            else
                [self.textView setText:content];
        }
    }
    [self.textView setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    self.textView.scrollEnabled = false;
    [self.textView layoutIfNeeded];
    self.textView.scrollEnabled = true;
}

-(IBAction)copy_clipboard:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textView.text;
    [MessageUtility showToast:NSLocalizedString(@"Toast.CopiedToClipboard", nil) inView:self.view];
}

@end
