// Part of Measurement Kit <https://measurement-kit.github.io/>.
// Measurement Kit is free software under the BSD license. See AUTHORS
// and LICENSE for more information on the copying conditions.

#import "MKOrchestra.h"

#import "measurement_kit/mkapi/orchestra.h"

#import "MKUtil.h"

MKUTIL_EXTEND_CLASS(MKOrchestraResult, mkapi_orchestra_result_t)

@implementation MKOrchestraResult

MKUTIL_INIT_WITH_POINTER(mkapi_orchestra_result_t)

MKUTIL_GET_BOOL(good, mkapi_orchestra_result_good)

MKUTIL_GET_DATA(getLogs, mkapi_orchestra_result_get_binary_logs)

MKUTIL_DEINIT(mkapi_orchestra_result_delete)

@end  // imlementation MKOrchestraResult

MKUTIL_EXTEND_CLASS(MKOrchestraClient, mkapi_orchestra_client_t)

@implementation MKOrchestraClient

MKUTIL_INIT_WITH_IMPLICIT_CA_ASN_COUNTRY(
  mkapi_orchestra_client_new,
  mkapi_orchestra_client_set_ca_bundle_path,
  mkapi_orchestra_client_set_geoip_asn_path,
  mkapi_orchestra_client_set_geoip_country_path)

MKUTIL_SET_STRING(setAvailableBandwidth,
  mkapi_orchestra_client_set_available_bandwidth)

MKUTIL_SET_STRING(setDeviceToken, mkapi_orchestra_client_set_device_token)

MKUTIL_SET_STRING(setLanguage, mkapi_orchestra_client_set_language)

MKUTIL_SET_STRING(setNetworkType, mkapi_orchestra_client_set_network_type)

MKUTIL_SET_STRING(setPlatform, mkapi_orchestra_client_set_platform)

MKUTIL_SET_STRING(setProbeASN, mkapi_orchestra_client_set_probe_asn)

MKUTIL_SET_STRING(setProbeCC, mkapi_orchestra_client_set_probe_cc)

MKUTIL_SET_STRING(setProbeFamily, mkapi_orchestra_client_set_probe_family)

MKUTIL_SET_STRING(setProbeTimezone, mkapi_orchestra_client_set_probe_timezone)

MKUTIL_SET_STRING(setRegistryURL, mkapi_orchestra_client_set_registry_url)

MKUTIL_SET_STRING(setSecretsFile, mkapi_orchestra_client_set_secrets_file)

MKUTIL_SET_STRING(setSoftwareName, mkapi_orchestra_client_set_software_name)

MKUTIL_SET_STRING(setSoftwareVersion,
  mkapi_orchestra_client_set_software_version)

MKUTIL_SET_STRING(addSupportedTest, mkapi_orchestra_client_add_supported_test)

MKUTIL_SET_INT(setTimeout, mkapi_orchestra_client_set_timeout)

MKUTIL_WRAP_GET_POINTER(MKOrchestraResult, sync, mkapi_orchestra_client_sync)

MKUTIL_DEINIT(mkapi_orchestra_client_delete)

@end  // implementation MKOrchestraClient
