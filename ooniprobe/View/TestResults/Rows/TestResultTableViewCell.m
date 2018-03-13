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
    [self.testIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_row", result.name]]];
    self.testNameLabel.text  = NSLocalizedString(result.name, nil);
    
    //TODO what to write when is null? (user disabled sharing asn)
    //TODO these methods can be the GET of relative classes
    NSString *asn = @"";
    NSString *asnName = @"";
    NSString *country = @"";
    if (result.asn) asn = result.asn;
    if (result.asnName) asnName = result.asnName;
    if (result.country) country = result.country;
    
    NSMutableAttributedString *asnNameAttr = [[NSMutableAttributedString alloc] initWithString:asnName];
    [asnNameAttr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"FiraSans-SemiBold" size:17]
                        range:NSMakeRange(0, asnNameAttr.length)];
    NSMutableAttributedString *asnText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [NSString stringWithFormat:@"%@ (%@)", asn, country]]];
    [asnText addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"FiraSans-Regular" size:17]
                    range:NSMakeRange(0, asnText.length)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    [attrStr appendAttributedString:asnNameAttr];
    [attrStr appendAttributedString:asnText];
    [self.testAsnLabel setAttributedText:attrStr];
    
    //from https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/InternationalizingLocaleData/InternationalizingLocaleData.html
    NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:result.startTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    self.testTimeLabel.text = localizedDateTime;
    Summary *summary = [result getSummary];
    if ([result.name isEqualToString:@"websites"]){
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:[UIImage imageNamed:@"x_red"]];
        [self.label1 setText:[NSString stringWithFormat:@"%ld %@", summary.blockedMeasurements, NSLocalizedString(@"blocked", nil)]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"globe_black"]];
        [self.label2 setText:[NSString stringWithFormat:@"%ld %@", summary.totalMeasurements, NSLocalizedString(@"tested", nil)]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if ([result.name isEqualToString:@"instant_messaging"]){
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:[UIImage imageNamed:@"x_red"]];
        [self.label1 setText:[NSString stringWithFormat:@"%ld %@", summary.blockedMeasurements, NSLocalizedString(@"blocked", nil)]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_red8 alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"tick_black"]];
        [self.label2 setText:[NSString stringWithFormat:@"%ld %@", summary.okMeasurements, NSLocalizedString(@"available", nil)]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
    else if ([result.name isEqualToString:@"middle_boxes"]){
        [self.stackView2 setHidden:YES];
        [self.stackView3 setHidden:YES];
        [self.image1 setImage:nil];
        if (summary.failedMeasurements > 0)
            [self.label1 setText:NSLocalizedString(@"found", nil)];
        else if (summary.okMeasurements == summary.totalMeasurements)
            [self.label1 setText:NSLocalizedString(@"not_found", nil)];
        else
            //TODO string
            [self.label1 setText:NSLocalizedString(@"failed", nil)];

        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_yellow8 alpha:1.0f]];
    }
    else if ([result.name isEqualToString:@"performance"]){
        [self.stackView2 setHidden:NO];
        [self.stackView3 setHidden:NO];
        [self.image1 setImage:[UIImage imageNamed:@"upload_black"]];
        [self.label1 setText:[NSString stringWithFormat:@"%@ %@", [summary getUpload], [summary getUploadUnit]]];
        [self.label1 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.image2 setImage:[UIImage imageNamed:@"download_black"]];
        [self.label2 setText:[NSString stringWithFormat:@"%@ %@", [summary getDownload], [summary getDownloadUnit]]];
        [self.label2 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
        [self.image3 setImage:[UIImage imageNamed:@"video_quality_black"]];
        [self.label3 setText:[summary getVideoQuality:YES]];
        [self.label3 setTextColor:[UIColor colorWithRGBHexString:color_black alpha:1.0f]];
    }
}

@end
