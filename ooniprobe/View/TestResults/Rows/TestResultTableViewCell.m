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
    if (!result.viewed)
        [self setBackgroundColor:[UIColor colorWithRGBHexString:color_yellow0 alpha:1.0f]];
    else
        [self setBackgroundColor:[UIColor clearColor]];
    
    [self.testIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", result.name]]];
    [self.testIcon setTintColor:[TestUtility getColorForTest:result.name]];

    self.testNameLabel.text  = [LocalizationUtility getNameForTest:result.name];
    NSString *asnName = [result getAsnName];
    
    NSMutableAttributedString *asnNameStr = [[NSMutableAttributedString alloc] initWithString:asnName];
    [asnNameStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                        range:NSMakeRange(0, asnNameStr.length)];
    [self.testAsnLabel setAttributedText:asnNameStr];
    
    //from https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/InternationalizingLocaleData/InternationalizingLocaleData.html
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:result.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.testTimeLabel.text = localizedDateTime;
    //TestKeys *testKeys = [self.measurement testKeysObj];
    if ([result.name isEqualToString:@"websites"]){
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:[UIImage imageNamed:@"cross"]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        //TODO [self.label1 setText:[NSString stringWithFormat:@"%d %@", summary.anomalousMeasurements, [LocalizationUtility getSingularPlural:summary.anomalousMeasurements :@"TestResults.Overview.Websites.Blocked"]]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"globe"]];
        [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        //TODO [self.label2 setText:[NSString stringWithFormat:@"%d %@", summary.totalMeasurements, [LocalizationUtility getSingularPlural:summary.totalMeasurements :@"TestResults.Overview.Websites.Tested"]]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if ([result.name isEqualToString:@"instant_messaging"]){
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:[UIImage imageNamed:@"cross"]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        //TODO [self.label1 setText:[NSString stringWithFormat:@"%d %@", summary.anomalousMeasurements, [LocalizationUtility getSingularPlural:summary.anomalousMeasurements :@"TestResults.Overview.InstantMessaging.Blocked"]]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"tick"]];
        [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        //TODO [self.label2 setText:[NSString stringWithFormat:@"%d %@", summary.okMeasurements, [LocalizationUtility getSingularPlural:summary.okMeasurements :@"TestResults.Overview.InstantMessaging.Available"]]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if ([result.name isEqualToString:@"middle_boxes"]){
        [self.stackView2 setHidden:YES];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:nil];
       /*TODO if (summary.anomalousMeasurements > 0)
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Found", nil)];
        else if (summary.okMeasurements == summary.totalMeasurements-summary.failedMeasurements)
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.NotFound", nil)];
        else
            [self.label1 setText:NSLocalizedString(@"TestResults.Overview.MiddleBoxes.Failed", nil)];
        */
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f]];
    }
    else if ([result.name isEqualToString:@"performance"]){
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:NO];
        [self.image1 setImage:[UIImage imageNamed:@"upload"]];
        [self.image1 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        //[self.label1 setText:[NSString stringWithFormat:@"%@", [testKeys getUploadWithUnit]]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"download"]];
        [self.image2 setTintColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        //[self.label2 setText:[NSString stringWithFormat:@"%@", [testKeys getDownloadWithUnit]]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.image3 setImage:[UIImage imageNamed:@"video_quality"]];
        //[self.label3 setText:[testKeys getVideoQuality:NO]];
        [self.label3 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
}

@end
