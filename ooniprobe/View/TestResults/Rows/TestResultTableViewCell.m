#import "TestResultTableViewCell.h"

@implementation TestResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setResult:(Result*)result{
    //Setting generic parameters
    [self.testIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", result.test_group_name]]];
    [self.testIcon setTintColor:[TestUtility getColorForTest:result.test_group_name]];
    [self.testNameLabel setTextColor:[TestUtility getColorForTest:result.test_group_name]];
    self.testNameLabel.text  = [LocalizationUtility getNameForTest:result.test_group_name];
    self.testTimeLabel.text = [result getLocalizedStartTime];
    [self.testTimeLabel setTextColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];
    [self.testAsnLabel setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.notUploadedImage setTintColor:[UIColor colorWithRGBHexString:color_gray7 alpha:1.0f]];

    if ([result.measurements count] == 0){
        //Bouncer error case
        [self.notUploadedImage setHidden:YES];
        [self setBackgroundColor:[UIColor colorWithRGBHexString:color_gray2 alpha:1.0f]];
        [self.testIcon setTintColor:[UIColor colorWithRGBHexString:color_gray6 alpha:1.0f]];
        [self.testNameLabel setTextColor:[UIColor colorWithRGBHexString:color_gray6 alpha:1.0f]];
        [self.testAsnLabel setText:[result getFailureMsg]];
        [self.stackView1 setHidden:YES];
        [self.stackView2 setHidden:YES];
        [self.stackView3 setHidden:YES];
        self.accessoryType = UITableViewCellAccessoryNone;
        return;
    }
    else {
        //Reset cell views state
        [self.stackView1 setHidden:NO];
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:NO];
    }
    
    if ([result isEveryMeasurementUploaded])
        [self.notUploadedImage setHidden:YES];
    else
        [self.notUploadedImage setHidden:NO];

    if (!result.is_viewed)
        [self setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow0 alpha:1.0f]];
    else
        [self setBackgroundColor:[UIColor clearColor]];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.testAsnLabel setText:[NSString stringWithFormat:@"%@ - %@", [result getAsn], [result getNetworkName]]];
    [self.stackView1 setAlpha:1.0f];
    [self.stackView2 setAlpha:1.0f];
    [self.stackView3 setAlpha:1.0f];

    //Setting test specific UI
    if ([result.test_group_name isEqualToString:@"websites"]){
        [self rowWebsites:result];
    }
    else if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        [self rowInstantMessaging:result];
    }
    else if ([result.test_group_name isEqualToString:@"middle_boxes"]){
        [self rowMiddleBoxes:result];
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        [self rowPerformance:result];
    }
}

-(void)rowWebsites:(Result*)result{
    long anomalousMeasurements = [result anomalousMeasurements];
    long totalMeasurements = [result totalMeasurements];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"exclamation_point"]];
    if (anomalousMeasurements == 0){
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    }
    else {
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
    }
    [self.label1 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:anomalousMeasurements :@"TestResults.Overview.Websites.Blocked"]]];
    [self.image2 setImage:[UIImage imageNamed:@"globe"]];
    [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.label2 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:totalMeasurements :@"TestResults.Overview.Websites.Tested"]]];
    [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];

}

-(void)rowInstantMessaging:(Result*)result{
    long anomalousMeasurements = [result anomalousMeasurements];
    long okMeasurements = [result okMeasurements];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"exclamation_point"]];
    if (anomalousMeasurements == 0){
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    }
    else {
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
    }
    [self.label1 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:anomalousMeasurements :@"TestResults.Overview.InstantMessaging.Blocked"]]];
    [self.image2 setImage:[UIImage imageNamed:@"tick"]];
    [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.label2 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:okMeasurements :@"TestResults.Overview.InstantMessaging.Available"]]];
    [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
}

-(void)rowPerformance:(Result*)result{
    Measurement *ndt = [result getMeasurement:@"ndt"];
    Measurement *dash = [result getMeasurement:@"dash"];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:NO];
    [self.image1 setImage:[UIImage imageNamed:@"download"]];
    [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.image2 setImage:[UIImage imageNamed:@"upload"]];
    [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    if (ndt){
        TestKeys *testKeysNdt = [result getMeasurement:@"ndt"].testKeysObj;
        [self setText:[testKeysNdt getDownloadWithUnit] forLabel:self.label1 inStackView:self.stackView1];
        [self setText:[testKeysNdt getUploadWithUnit] forLabel:self.label2 inStackView:self.stackView2];
    }
    else {
        [self.label1 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
        [self.stackView1 setAlpha:0.3f];
        [self.label2 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
        [self.stackView2 setAlpha:0.3f];
    }
    [self.image3 setImage:[UIImage imageNamed:@"video_quality"]];
    if (dash){
        TestKeys *testKeysDash = [result getMeasurement:@"dash"].testKeysObj;
        [self setText:[testKeysDash getVideoQuality:NO] forLabel:self.label3 inStackView:self.stackView3];
    }
    else {
        [self.label3 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
        [self.stackView3 setAlpha:0.3f];
    }
    [self.label3 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
}

-(void)rowMiddleBoxes:(Result*)result{
    long anomalousMeasurements = [result anomalousMeasurements];
    [self.stackView2 setHidden:YES];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"middle_boxes"]];
    if (anomalousMeasurements > 0){
        [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Found", nil)];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_yellow9 alpha:1.0f]];
    }
    else if ([result totalMeasurements] == [result failedMeasurements]){
        [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Failed", nil)];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    }
    else {
        [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.NotFound", nil)];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
    }
}

-(void)setText:(NSString*)text forLabel:(UILabel*)label inStackView:(UIStackView*)stackView{
    if (text == nil)
        text = NSLocalizedString(@"TestResults.NotAvailable", nil);
    [label setText:text];
    if ([text isEqualToString:NSLocalizedString(@"TestResults.NotAvailable", nil)]){
        [stackView setAlpha:0.3f];
    }
}

@end
