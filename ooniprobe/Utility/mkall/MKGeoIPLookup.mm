// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.

// Note: this file is Objective-C++ because otherwise the whole project
// will compile as Objective-C and link will fail mentioning that several
// C++ related symbols are missing (of course).

#import "MKGeoIPLookup.h"

#import "measurement_kit/vendor/mkgeoip.h"

#import "MKUtil.h"

MKUTIL_EXTEND_CLASS(MKGeoIPLookupResults, mkgeoip_lookup_results_t)

@implementation MKGeoIPLookupResults

MKUTIL_INIT_WITH_POINTER(mkgeoip_lookup_results_t)

MKUTIL_GET_BOOL(good, mkgeoip_lookup_results_good_v2)

MKUTIL_GET_DOUBLE(getBytesSent, mkgeoip_lookup_results_get_bytes_sent_v2)

MKUTIL_GET_DOUBLE(getBytesRecv, mkgeoip_lookup_results_get_bytes_recv_v2)

MKUTIL_GET_STRING(getProbeIP, mkgeoip_lookup_results_get_probe_ip_v2)

MKUTIL_GET_INT(getProbeASN, mkgeoip_lookup_results_get_probe_asn_v2)

MKUTIL_GET_STRING(getProbeCC, mkgeoip_lookup_results_get_probe_cc_v2)

MKUTIL_GET_STRING(getProbeOrg, mkgeoip_lookup_results_get_probe_org_v2)

MKUTIL_GET_DATA(getLogs, mkgeoip_lookup_results_get_logs_binary_v2)

MKUTIL_DEINIT(mkgeoip_lookup_results_delete)

@end  // implementation MKGeoIPLookupResults

MKUTIL_EXTEND_CLASS(MKGeoIPLookupSettings, mkgeoip_lookup_settings_t)

@implementation MKGeoIPLookupSettings

MKUTIL_INIT_WITH_IMPLICIT_CA_ASN_COUNTRY(
  mkgeoip_lookup_settings_new_nonnull,
  mkgeoip_lookup_settings_set_ca_bundle_path_v2,
  mkgeoip_lookup_settings_set_asn_db_path_v2,
  mkgeoip_lookup_settings_set_country_db_path_v2)

MKUTIL_SET_INT(setTimeout, mkgeoip_lookup_settings_set_timeout_v2)

MKUTIL_WRAP_GET_POINTER(MKGeoIPLookupResults, perform,
  mkgeoip_lookup_settings_perform_nonnull)

MKUTIL_DEINIT(mkgeoip_lookup_settings_delete)

@end  // implementation MKGeoIPLookupSettings

