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
    if (!result.is_viewed)
        [self setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow0 alpha:1.0f]];
    else
        [self setBackgroundColor:[UIColor clearColor]];
    
    [self.testIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", result.test_group_name]]];
    [self.testIcon setTintColor:[TestUtility getColorForTest:result.test_group_name]];

    self.testNameLabel.text  = [LocalizationUtility getNameForTest:result.test_group_name];
    NSString *asnName = [result getAsnName];
    
    NSMutableAttributedString *asnNameStr = [[NSMutableAttributedString alloc] initWithString:asnName];
    [asnNameStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                        range:NSMakeRange(0, asnNameStr.length)];
    [self.testAsnLabel setAttributedText:asnNameStr];
    
    //from https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/InternationalizingLocaleData/InternationalizingLocaleData.html
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:result.start_time dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.testTimeLabel.text = localizedDateTime;
    if ([result.test_group_name isEqualToString:@"websites"]){
        long anomalousMeasurements = [result anomalousMeasurements];
        long totalMeasurements = [result totalMeasurements];
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:[UIImage imageNamed:@"cross"]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.label1 setText:[NSString stringWithFormat:@"%ld %@", anomalousMeasurements, [LocalizationUtility getSingularPlural:anomalousMeasurements :@"TestResults.Overview.Websites.Blocked"]]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"globe"]];
        [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.label2 setText:[NSString stringWithFormat:@"%ld %@", totalMeasurements, [LocalizationUtility getSingularPlural:totalMeasurements :@"TestResults.Overview.Websites.Tested"]]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if ([result.test_group_name isEqualToString:@"instant_messaging"]){
        long anomalousMeasurements = [result anomalousMeasurements];
        long okMeasurements = [result okMeasurements];
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:[UIImage imageNamed:@"cross"]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.label1 setText:[NSString stringWithFormat:@"%ld %@", anomalousMeasurements, [LocalizationUtility getSingularPlural:anomalousMeasurements :@"TestResults.Overview.InstantMessaging.Blocked"]]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"tick"]];
        [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.label2 setText:[NSString stringWithFormat:@"%ld %@", okMeasurements, [LocalizationUtility getSingularPlural:okMeasurements :@"TestResults.Overview.InstantMessaging.Available"]]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if ([result.test_group_name isEqualToString:@"middle_boxes"]){
        long anomalousMeasurements = [result anomalousMeasurements];
        [self.stackView2 setHidden:YES];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:nil];
        if (anomalousMeasurements > 0){
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Found", nil)];
            [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f]];
        }
        else if ([result totalMeasurements] == 0){
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Failed", nil)];
            [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        }
        else if ([result okMeasurements] == [result totalMeasurements]-[result failedMeasurements]){
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.NotFound", nil)];
            [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_green7 alpha:1.0f]];
        }
        else {
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Failed", nil)];
            [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_gray9 alpha:1.0f]];
        }
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f]];
    }
    else if ([result.test_group_name isEqualToString:@"performance"]){
        Measurement *ndt = [result getMeasurement:@"ndt"];
        Measurement *dash = [result getMeasurement:@"dash"];
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:NO];
        [self.image1 setImage:[UIImage imageNamed:@"upload"]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        if (ndt){
            [self.label1 setText:[NSString stringWithFormat:@"%@", [[result getMeasurement:@"ndt"].testKeysObj getUploadWithUnit]]];
            [self.label2 setText:[NSString stringWithFormat:@"%@", [[result getMeasurement:@"ndt"].testKeysObj getDownloadWithUnit]]];
        }
        else {
            [self.label1 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
            [self.label2 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
        }
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"download"]];
        [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.image3 setImage:[UIImage imageNamed:@"video_quality"]];
        if (dash){
            [self.label3 setText:[[result getMeasurement:@"dash"].testKeysObj getVideoQuality:NO]];
        }
        else {
            [self.label3 setText:[NSString stringWithFormat:@"%@", NSLocalizedString(@"TestResults.NotAvailable", nil)]];
        }
        [self.label3 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
}

@end
