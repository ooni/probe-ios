#import "UploadFooterViewController.h"
#import "MessageUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsUtility.h"
#import <mkall/MKCollector.h>
#import "TestUtility.h"
#import "MBProgressHUD.h"

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
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = NSLocalizedString(@"Modal.ResultsNotUploaded.Uploading", nil);
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doUploadWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadFinished" object:nil];
    });
}

- (void)doUploadWithProgress {
    if (self.result == nil && self.measurement == nil && self.upload_all) {
        //upload ALL
        SRKResultSet *notUploaded = [Measurement notUploadedMeasurements];
        [self uploadMeasurements:notUploaded];
    }
    else if (self.result != nil && self.measurement == nil && self.upload_all) {
        //upload all measurements of that result
        SRKResultSet *notUploaded = [self.result notUploadedMeasurements];
        [self uploadMeasurements:notUploaded];
    }
    else if (self.result != nil && self.measurement != nil && !self.upload_all) {
        //upload this measurement
        [self uploadSingleMeasurement:self.measurement];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD HUDForView:self.navigationController.view].progress = 1;
        });
    }
}

-(void)uploadMeasurements:(SRKResultSet *)notUploaded{
    if ([notUploaded count] == 0) return;
    float progress = 0.0f;
    float measurementValue = 1.0/[notUploaded count];
    int done = 1;
    for (Measurement *currentMeasurement in notUploaded){
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD HUDForView:self.navigationController.view].label.text = NSLocalizedFormatString(@"Modal.ResultsNotUploaded.Uploading", [NSString stringWithFormat:@"%d/%ld", done, [notUploaded count]]);
        });
        [self uploadSingleMeasurement:currentMeasurement];
        progress += measurementValue;
        done++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
    }
}

-(void)uploadSingleMeasurement:(Measurement*)measurement{
    NSString *content = [TestUtility getFileContent:[measurement getReportFile]];
    MKCollectorResubmitSettings *settings = [[MKCollectorResubmitSettings alloc] init];
    [settings setSerializedMeasurement:content];
    MKCollectorResubmitResults *results = [settings perform];
    if ([results good]){
        //save updated file
        [TestUtility writeString:[results updatedSerializedMeasurement] toFile:[TestUtility getFileNamed:[measurement getReportFile]]];
        //NSLog(@"updatedMeasurement: %@", [results updatedSerializedMeasurement]);
        //NSLog(@"logs: %@", [results logs]);
        measurement.is_uploaded = true;
        measurement.is_upload_failed = false;
        [measurement setReport_id:@"FAKE_REPORT_ID"];
        [measurement save];
    }
}

@end
