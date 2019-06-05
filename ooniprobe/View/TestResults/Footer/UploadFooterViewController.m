#import "UploadFooterViewController.h"
#import "MessageUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "SettingsUtility.h"
#import <mkall/MKCollector.h>
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

-(void)uploadMeasurements:(NSArray *)notUploaded {
    [self uploadMeasurements:notUploaded startAt:0];
}

//SRKResultSet is a subclass of NSArray
-(void)uploadMeasurements:(NSArray *)notUploaded startAt:(NSUInteger)idx{
    //TODO handle it in a background task
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
        });
        if ([notUploaded count] == 0) return;
        NSUInteger i = idx;
        float progress = 0.0f;
        //The progress should consider the array size - the idx of first element to actually be uploaded
        float measurementValue = 1.0/([notUploaded count] - i);
        while (i < [notUploaded count]){
            Measurement *currentMeasurement = [notUploaded objectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD HUDForView:self.navigationController.view].label.text =
                NSLocalizedFormatString(@"Modal.ResultsNotUploaded.Uploading",
                                        [NSString stringWithFormat:@"%ld/%ld", i+1, ([notUploaded count] - idx)]);
            });
            if (![self uploadMeasurement:currentMeasurement]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showRetryPopup:notUploaded startAt:i];
                });
                break;
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadFinished" object:nil];
    });
}

-(BOOL)uploadMeasurement:(Measurement*)measurement{
    NSString *content = [TestUtility getUTF8FileContent:[measurement getReportFile]];
    NSUInteger bytes = [content lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    MKCollectorResubmitTask *task = [[MKCollectorResubmitTask alloc]
                                     initWithSerializedMeasurement:content
                                     softwareName:SOFTWARE_NAME
                                     softwareVersion:[VersionUtility get_software_version]
                                     ];
    [task setTimeout:[TestUtility makeTimeout:bytes]];
    MKCollectorResubmitResults *results = [task perform];
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

-(void)showRetryPopup:(NSArray *)notUploaded startAt:(NSUInteger)start{
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Modal.Retry", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   [self uploadMeasurements:notUploaded startAt:start];
                               }];
    [MessageUtility alertWithTitle:NSLocalizedString(@"Modal.UploadFailed.Title", nil)
                           message:NSLocalizedString(@"Modal.UploadFailed.Paragraph", nil)
                          okButton:okButton
                            inView:self];

}
@end
