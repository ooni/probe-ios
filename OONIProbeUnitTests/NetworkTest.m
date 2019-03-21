#import <XCTest/XCTest.h>
#import "Network.h"

#define BLANK @""
#define IP_ADDRESS @"1.1.1.1"
#define ASN @"asn"
#define NETWORK_NAME @"network_name"
#define COUNTRY_CODE @"country_code"
#define NETWORK_TYPE @"wifi"
#define UNKNOWN NSLocalizedString(@"TestResults.UnknownASN", nil)

@interface NetworkTest : XCTestCase

@end

@implementation NetworkTest
Network *network;

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    network = [Network new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAsn {
    XCTAssert([[network getAsn] isEqualToString:UNKNOWN]);
    network.asn = BLANK;
    XCTAssert([[network getAsn] isEqualToString:UNKNOWN]);
    network.asn = ASN;
    XCTAssert([[network getAsn] isEqualToString:ASN]);
}

- (void)testNetworkName {
    XCTAssert([[network getNetworkName] isEqualToString:UNKNOWN]);
    network.network_name = BLANK;
    XCTAssert([[network getNetworkName] isEqualToString:UNKNOWN]);
    network.network_name = NETWORK_NAME;
    XCTAssert([[network getNetworkName] isEqualToString:NETWORK_NAME]);
}

-(void)testNameOrAsn{
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:UNKNOWN]);
    network.network_name = BLANK;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:UNKNOWN]);
    network.asn = BLANK;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:UNKNOWN]);
    network.asn = ASN;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:ASN]);
    network.network_name = NETWORK_NAME;
    XCTAssert([[network getNetworkNameOrAsn] isEqualToString:NETWORK_NAME]);
}

- (void)testCountry {
    XCTAssert([[network getCountry] isEqualToString:UNKNOWN]);
    network.country_code = BLANK;
    XCTAssert([[network getCountry] isEqualToString:UNKNOWN]);
    network.country_code = COUNTRY_CODE;
    XCTAssert([[network getCountry] isEqualToString:COUNTRY_CODE]);
}

- (void)testNetworkCreation {
    //Create and verify
    Network * newNetwork = [Network checkExistingNetworkWithAsn:ASN networkName:NETWORK_NAME ip:IP_ADDRESS cc:COUNTRY_CODE networkType:NETWORK_TYPE];
    XCTAssert([[newNetwork getCountry] isEqualToString:COUNTRY_CODE]);
    XCTAssert([[newNetwork getNetworkName] isEqualToString:NETWORK_NAME]);
    XCTAssert([[newNetwork getAsn] isEqualToString:ASN]);
}

- (void)testNetworkUpdate {
    //Create and update and verify
    Network * newNetwork = [Network checkExistingNetworkWithAsn:BLANK networkName:BLANK ip:IP_ADDRESS cc:BLANK networkType:NETWORK_TYPE];
    XCTAssert([[newNetwork getCountry] isEqualToString:UNKNOWN]);
    newNetwork.country_code = COUNTRY_CODE;
    //TODO test retrivial from db
    //[newNetwork save];
    //newNetwork = [Network checkExistingNetworkWithAsn:BLANK networkName:BLANK ip:IP_ADDRESS cc:COUNTRY_CODE networkType:NETWORK_TYPE];
    XCTAssert([[newNetwork getCountry] isEqualToString:COUNTRY_CODE]);

    XCTAssert([[newNetwork getNetworkName] isEqualToString:UNKNOWN]);
    newNetwork.network_name = NETWORK_NAME;
    XCTAssert([[newNetwork getNetworkName] isEqualToString:NETWORK_NAME]);
    
    XCTAssert([[newNetwork getAsn] isEqualToString:UNKNOWN]);
    newNetwork.asn = ASN;
    XCTAssert([[newNetwork getAsn] isEqualToString:ASN]);
}

@end
