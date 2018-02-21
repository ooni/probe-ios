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
    [self.testIcon setImage:[UIImage imageNamed:result.name]];
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
}

@end
