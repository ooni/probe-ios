#import "UploadFooterViewController.h"
#import "MessageUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsUtility.h"
#import <mkall/MKCollector.h>
#import "TestUtility.h"

@interface UploadFooterViewController ()

@end

@implementation UploadFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_upload_all){
        //test results and test summary
        [self.titleLabel setText:NSLocalizedString(@"Snackbar.ResultsSomeNotUploaded.Text", nil)];
        [self.uploadButton setTitle:NSLocalizedString(@"Snackbar.ResultsSomeNotUploaded.UploadAll", nil) forState:UIControlStateNormal];
    }
    else {
        //test details
        [self.titleLabel setText:NSLocalizedString(@"Snackbar.ResultsNotUploaded.Text", nil)];
        [self.uploadButton setTitle:NSLocalizedString(@"Snackbar.ResultsNotUploaded.Upload", nil) forState:UIControlStateNormal];
    }
    self.uploadButton.layer.cornerRadius = self.uploadButton.bounds.size.height/2;
    self.uploadButton.layer.masksToBounds = YES;
    self.uploadButton.layer.borderWidth = 1.0f;
    self.uploadButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

-(IBAction)upload{
    if (_upload_all){
        [self showModalHelp];
    }
    else {
        [self uploadResult];
    }
}

-(void)showModalHelp{
    //TODO should we add a don't ask again button?
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.ResultsNotUploaded.Button.Upload", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   [self uploadResult];
                               }];
    [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.ResultsNotUploaded.Title", nil)
                           message:NSLocalizedString(@"Modal.ResultsNotUploaded.Paragraph", nil)
                          okButton:okButton
                            inView:self];
}

-(void)uploadResult{
    //TODO call relative mk function.
    if (result == nil && measurement == nil && upload_all) {
        //upload ALL
    }
    else if (result != nil && measurement == nil && upload_all) {
        //upload all measurements of that result
    }
    else if (result != nil && measurement != nil && !upload_all) {
        //upload this measurement
        [self uploadMeasurement:self.measurement];
    }
}

-(void)uploadMeasurement:(Measurement*)measurement{
    NSString *content = [TestUtility getFileContent:[measurement getReportFile]];
    MKCollectorResubmitSettings *settings = [[MKCollectorResubmitSettings alloc] init];
    [settings setSerializedMeasurement:content];
    MKCollectorResubmitResults *results = [settings perform];
    if ([results good]){
        NSLog(@"good: %d", [results good]);
        NSLog(@"updatedMeasurement: %@", [results updatedSerializedMeasurement]);
        NSLog(@"logs: %@", [results logs]);
    }
}

- (void)uploadFinished{
    //TODO reload every table/screen
}

@end
