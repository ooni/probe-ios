#import "UploadFooterViewController.h"
#import "MessageUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsUtility.h"
#import <mkall/MKReporter.h>
#import "TestUtility.h"
#import "MBProgressHUD.h"
#import "VersionUtility.h"

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
    self.backgroundTask = UIBackgroundTaskInvalid;
}

-(IBAction)upload{
    if (self.upload_all){
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

- (void)uploadResult {
    if (self.result == nil && self.measurement == nil && self.upload_all) {
        //upload ALL
        [self uploadMeasurements:[Measurement notUploadedMeasurements]];
    }
    else if (self.result != nil && self.measurement == nil && self.upload_all) {
        //upload all measurements of that result
        [self uploadMeasurements:[self.result notUploadedMeasurements]];
    }
    else if (self.result != nil && self.measurement != nil && !self.upload_all) {
        //upload this measurement
        [self uploadMeasurements:[NSArray arrayWithObject:self.measurement]];
    }
}

//SRKResultSet is a subclass of NSArray
-(void)uploadMeasurements:(NSArray *)notUploaded{
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.bezelView.color = [UIColor lightGrayColor];
            hud.backgroundView.style = UIBlurEffectStyleRegular;
        });
        NSUInteger errors = 0;
        if ([notUploaded count] == 0) return;
        NSUInteger i = 0;
        float progress = 0.0f;
        float measurementValue = 1.0/([notUploaded count]);
        MKReporterTask *task = [[MKReporterTask alloc]
          initWithSoftwareName:SOFTWARE_NAME
          softwareVersion:[VersionUtility get_software_version]];
        while (i < [notUploaded count]){
            Measurement *currentMeasurement = [notUploaded objectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD HUDForView:self.navigationController.view].label.text =
                NSLocalizedFormatString(@"Modal.ResultsNotUploaded.Uploading",
                                        [NSString stringWithFormat:@"%ld/%ld", i+1, [notUploaded count]]);
            });
            if (![self uploadMeasurement:currentMeasurement reporterTask:task]){
                errors++;
            }
            progress += measurementValue;
            i++;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
        if (errors == 0)
            [MessageUtility showToast:NSLocalizedString(@"Toast.ResultsUploaded", nil) inView:self.navigationController.view];
        else {
            // show  number of errors in retry popup.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showRetryPopup:[notUploaded count] withErrors:errors];
            });
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadFinished" object:nil];
    });
}

-(BOOL)uploadMeasurement:(Measurement*)measurement
            reporterTask:(MKReporterTask *)task {
    NSString *content = [TestUtility getUTF8FileContent:[measurement getReportFile]];
    NSUInteger bytes = [content lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    MKReporterResults *results = [
      task submit:content uploadTimeout:[TestUtility makeTimeout:bytes]];
    if ([results good]){
        //save updated file
        [TestUtility writeString:[results updatedSerializedMeasurement] toFile:[TestUtility getFileNamed:[measurement getReportFile]]];
        measurement.is_uploaded = true;
        measurement.is_upload_failed = false;
        [measurement setReport_id:[results updatedReportID]];
        [measurement save];
    }
    return [results good];
}

-(void)showRetryPopup:(NSInteger)numUploads withErrors:(NSInteger)errors{
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.Retry", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                    //Reload DB query and restart upload
                                   [self uploadResult];
                               }];
    NSString *paragraph = NSLocalizedFormatString(@"Modal.UploadFailed.Paragraph",
                                                  [NSString stringWithFormat:@"%ld", (long)numUploads],
                                                  [NSString stringWithFormat:@"%ld", (long)errors]);
    [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.UploadFailed.Title", nil)
                           message:paragraph
                          okButton:okButton
                            inView:self];

}
@end
