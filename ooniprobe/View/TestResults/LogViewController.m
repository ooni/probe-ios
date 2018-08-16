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
        NSString *filePath = [TestUtility getFileName:self.measurement ext:self.type];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:filePath]) {
            NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            if ([self.type isEqualToString:@"json"]){
                NSError *error;
                NSData *jsonData = [content dataUsingEncoding:NSUTF8StringEncoding];
                id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
                JSONSyntaxHighlight *jsh = [[JSONSyntaxHighlight alloc] initWithJSON:jsonObject];
                NSAttributedString *s;
                s = [jsh highlightJSON];
                [self.textView setAttributedText:s];
            }
            else
                [self.textView setText:content];
        }
    }
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
