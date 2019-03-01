//
//  NetworkTest.m
//  OONIProbeUnitTests
//
//  Created by Lorenzo Primiterra on 01/03/2019.
//  Copyright © 2019 OONI. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Network.h"

#define BLANK = @"";
#define ASN = @"asn";
#define NETWORK_NAME = @"network_name";
#define COUNTRY_CODE = @"country_code";

@interface NetworkTest : XCTestCase

@end

@implementation NetworkTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)asn {
    /*
     Assert.assertEquals(Network.getAsn(c, null), c.getString(R.string.TestResults_UnknownASN));
     Assert.assertEquals(Network.getAsn(c, new Network()), c.getString(R.string.TestResults_UnknownASN));
     Network n = new Network();
     n.asn = "";
     Assert.assertEquals(Network.getAsn(c, n), c.getString(R.string.TestResults_UnknownASN));
     n.asn = ASN;
     Assert.assertEquals(Network.getAsn(c, n), ASN);
     */
    Network.getAsn
    XCTAssert(Network.getAsn(c, null), NSLocalizedString(@"TestResults.UnknownASN", nil));
}

- (void)name {
    /*
     Assert.assertEquals(Network.getName(c, null), c.getString(R.string.TestResults_UnknownASN));
     Assert.assertEquals(Network.getName(c, new Network()), c.getString(R.string.TestResults_UnknownASN));
     Network n = new Network();
     n.network_name = BLANK;
     Assert.assertEquals(Network.getName(c, n), c.getString(R.string.TestResults_UnknownASN));
     n.network_name = NETWORK_NAME;
     Assert.assertEquals(Network.getName(c, n), NETWORK_NAME);
     */
}

- (void)country {
    /*
     Assert.assertEquals(Network.getCountry(c, null), c.getString(R.string.TestResults_UnknownASN));
     Assert.assertEquals(Network.getCountry(c, new Network()), c.getString(R.string.TestResults_UnknownASN));
     Network n = new Network();
     n.country_code = BLANK;
     Assert.assertEquals(Network.getCountry(c, n), c.getString(R.string.TestResults_UnknownASN));
     n.country_code = COUNTRY_CODE;
     Assert.assertEquals(Network.getCountry(c, n), COUNTRY_CODE);

     */
}

@end
