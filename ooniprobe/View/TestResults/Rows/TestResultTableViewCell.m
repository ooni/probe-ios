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
    [self.testTimeLabel setTextColor:[UIColor colorNamed:@"color_gray7"]];
    [self.testAsnLabel setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.notUploadedImage setTintColor:[UIColor colorNamed:@"color_gray7"]];

    if ([result.measurements count] == 0){
        //Bouncer error case
        [self.notUploadedImage setHidden:YES];
        [self setBackgroundColor:[UIColor colorNamed:@"color_gray2"]];
        [self.testIcon setTintColor:[UIColor colorNamed:@"color_gray6"]];
        [self.testNameLabel setTextColor:[UIColor colorNamed:@"color_gray6"]];
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
        [self setBackgroundColor:[UIColor colorNamed:@"color_yellow0"]];
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
    else if ([result.test_group_name isEqualToString:@"circumvention"]){
        [self rowCircumvention:result];
    }
}

-(void)rowWebsites:(Result*)result{
    long anomalousMeasurements = [result anomalousMeasurements];
    long totalMeasurements = [result totalMeasurements];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"exclamation_point"]];
    if (anomalousMeasurements == 0){
        [self.image1 setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_gray9"]];
    }
    else {
        [self.image1 setTintColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_yellow9"]];
    }
    [self.label1 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:anomalousMeasurements :@"TestResults.Overview.Websites.Blocked"]]];
    [self.image2 setImage:[UIImage imageNamed:@"globe"]];
    [self.image2 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    [self.label2 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:totalMeasurements :@"TestResults.Overview.Websites.Tested"]]];
    [self.label2 setTextColor:[UIColor colorNamed:@"color_gray9"]];

}

-(void)rowInstantMessaging:(Result*)result{
    long anomalousMeasurements = [result anomalousMeasurements];
    long okMeasurements = [result okMeasurements];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"exclamation_point"]];
    if (anomalousMeasurements == 0){
        [self.image1 setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_gray9"]];
    }
    else {
        [self.image1 setTintColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_yellow9"]];
    }
    [self.label1 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:anomalousMeasurements :@"TestResults.Overview.InstantMessaging.Blocked"]]];
    [self.image2 setImage:[UIImage imageNamed:@"tick"]];
    [self.image2 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    [self.label2 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:okMeasurements :@"TestResults.Overview.InstantMessaging.Available"]]];
    [self.label2 setTextColor:[UIColor colorNamed:@"color_gray9"]];
}

//TODO Refactor with rowInstantMessaging
-(void)rowCircumvention:(Result*)result{
    long anomalousMeasurements = [result anomalousMeasurements];
    long okMeasurements = [result okMeasurements];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"exclamation_point"]];
    if (anomalousMeasurements == 0){
        [self.image1 setTintColor:[UIColor colorNamed:@"color_gray9"]];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_gray9"]];
    }
    else {
        [self.image1 setTintColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_yellow9"]];
    }
    [self.label1 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:anomalousMeasurements :@"TestResults.Overview.Circumvention.Blocked"]]];
    [self.image2 setImage:[UIImage imageNamed:@"tick"]];
    [self.image2 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    [self.label2 setText:[NSString stringWithFormat:@"%@", [LocalizationUtility getSingularPluralTemplate:okMeasurements :@"TestResults.Overview.Circumvention.Available"]]];
    [self.label2 setTextColor:[UIColor colorNamed:@"color_gray9"]];
}

-(void)rowPerformance:(Result*)result{
    Measurement *ndt = [result getMeasurement:@"ndt"];
    Measurement *dash = [result getMeasurement:@"dash"];
    [self.stackView2 setHidden:NO];
    [self.stackView3 setHidden:NO];
    [self.image1 setImage:[UIImage imageNamed:@"download"]];
    [self.image1 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    [self.label1 setTextColor:[UIColor colorNamed:@"color_gray9"]];
    [self.image2 setImage:[UIImage imageNamed:@"upload"]];
    [self.image2 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    [self.label2 setTextColor:[UIColor colorNamed:@"color_gray9"]];
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
    [self.image3 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    if (dash){
        TestKeys *testKeysDash = [result getMeasurement:@"dash"].testKeysObj;
        [self setText:[testKeysDash getVideoQuality:NO] forLabel:self.label3 inStackView:self.stackView3];
    }
    else {
        [self.label3 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
        [self.stackView3 setAlpha:0.3f];
    }
    [self.label3 setTextColor:[UIColor colorNamed:@"color_gray9"]];
}

-(void)rowMiddleBoxes:(Result*)result __deprecated{
    long anomalousMeasurements = [result anomalousMeasurements];
    [self.stackView2 setHidden:YES];
    [self.stackView3 setHidden:YES];
    [self.image1 setImage:[UIImage imageNamed:@"middle_boxes"]];
    if (anomalousMeasurements > 0){
        [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Found", nil)];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_yellow9"]];
        [self.image1 setTintColor:[UIColor colorNamed:@"color_yellow9"]];
    }
    else if ([result totalMeasurements] == [result failedMeasurements]){
        [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Failed", nil)];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.image1 setTintColor:[UIColor colorNamed:@"color_gray9"]];
    }
    else {
        [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.NotFound", nil)];
        [self.label1 setTextColor:[UIColor colorNamed:@"color_gray9"]];
        [self.image1 setTintColor:[UIColor colorNamed:@"color_gray9"]];
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
