// Copyright 2024 KU Leuven.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Yunhao Deng <yunhao.deng@kuleuven.be>

// This file provides the function to read and write CSR with CSR address in
// register As CSR instruction in RISC-V is immediate-number addressed, this
// workaround function deploys a switch-case to map the CSR address to implement
// pseudo register-mapping mechanism. To avoid the loss of performance, the
// function is defined in header, so that it can be compiled together with the
// main program, and optimized by the compiler. If @csr_address is provided in
// an immediate number, (macros, constant etc.) the compiler won't add it in a
// separate function creating loss in switching cycles.

#ifndef CSR_H
#define CSR_H
#define CSR_LONG_ADDR_MODE
// Uncomment the above line to enable 64 CSRs addressability, with the down side
// of larger binary size.

static void write_csr_obs(uint32_t value) {
    write_csr(1989, value);
    return;
}

static uint32_t read_csr_obs(void) { return read_csr(1989); }

static uint32_t csrr_ss(uint32_t csr_address) {
    uint32_t value;
    switch (csr_address) {
        case 960:
            return read_csr(960);
        case 961:
            return read_csr(961);
        case 962:
            return read_csr(962);
        case 963:
            return read_csr(963);
        case 964:
            return read_csr(964);
        case 965:
            return read_csr(965);
        case 966:
            return read_csr(966);
        case 967:
            return read_csr(967);
        case 968:
            return read_csr(968);
        case 969:
            return read_csr(969);
        case 970:
            return read_csr(970);
        case 971:
            return read_csr(971);
        case 972:
            return read_csr(972);
        case 973:
            return read_csr(973);
        case 974:
            return read_csr(974);
        case 975:
            return read_csr(975);
        case 976:
            return read_csr(976);
        case 977:
            return read_csr(977);
        case 978:
            return read_csr(978);
        case 979:
            return read_csr(979);
        case 980:
            return read_csr(980);
        case 981:
            return read_csr(981);
        case 982:
            return read_csr(982);
        case 983:
            return read_csr(983);
        case 984:
            return read_csr(984);
        case 985:
            return read_csr(985);
        case 986:
            return read_csr(986);
        case 987:
            return read_csr(987);
        case 988:
            return read_csr(988);
        case 989:
            return read_csr(989);
        case 990:
            return read_csr(990);
        case 991:
            return read_csr(991);
#ifdef CSR_LONG_ADDR_MODE
        case 992:
            return read_csr(992);
        case 993:
            return read_csr(993);
        case 994:
            return read_csr(994);
        case 995:
            return read_csr(995);
        case 996:
            return read_csr(996);
        case 997:
            return read_csr(997);
        case 998:
            return read_csr(998);
        case 999:
            return read_csr(999);
        case 1000:
            return read_csr(1000);
        case 1001:
            return read_csr(1001);
        case 1002:
            return read_csr(1002);
        case 1003:
            return read_csr(1003);
        case 1004:
            return read_csr(1004);
        case 1005:
            return read_csr(1005);
        case 1006:
            return read_csr(1006);
        case 1007:
            return read_csr(1007);
        case 1008:
            return read_csr(1008);
        case 1009:
            return read_csr(1009);
        case 1010:
            return read_csr(1010);
        case 1011:
            return read_csr(1011);
        case 1012:
            return read_csr(1012);
        case 1013:
            return read_csr(1013);
        case 1014:
            return read_csr(1014);
        case 1015:
            return read_csr(1015);
        case 1016:
            return read_csr(1016);
        case 1017:
            return read_csr(1017);
        case 1018:
            return read_csr(1018);
        case 1019:
            return read_csr(1019);
        case 1020:
            return read_csr(1020);
        case 1021:
            return read_csr(1021);
        case 1022:
            return read_csr(1022);
        case 1023:
            return read_csr(1023);
        case 1024:
            return read_csr(1024);
        case 1025:
            return read_csr(1025);
        case 1026:
            return read_csr(1026);
        case 1027:
            return read_csr(1027);
        case 1028:
            return read_csr(1028);
        case 1029:
            return read_csr(1029);
        case 1030:
            return read_csr(1030);
        case 1031:
            return read_csr(1031);
        case 1032:
            return read_csr(1032);
        case 1033:
            return read_csr(1033);
        case 1034:
            return read_csr(1034);
        case 1035:
            return read_csr(1035);
        case 1036:
            return read_csr(1036);
        case 1037:
            return read_csr(1037);
        case 1038:
            return read_csr(1038);
        case 1039:
            return read_csr(1039);
        case 1040:
            return read_csr(1040);
        case 1041:
            return read_csr(1041);
        case 1042:
            return read_csr(1042);
        case 1043:
            return read_csr(1043);
        case 1044:
            return read_csr(1044);
        case 1045:
            return read_csr(1045);
        case 1046:
            return read_csr(1046);
        case 1047:
            return read_csr(1047);
        case 1048:
            return read_csr(1048);
        case 1049:
            return read_csr(1049);
        case 1050:
            return read_csr(1050);
        case 1051:
            return read_csr(1051);
        case 1052:
            return read_csr(1052);
        case 1053:
            return read_csr(1053);
        case 1054:
            return read_csr(1054);
        case 1055:
            return read_csr(1055);
        case 1056:
            return read_csr(1056);
        case 1057:
            return read_csr(1057);
        case 1058:
            return read_csr(1058);
        case 1059:
            return read_csr(1059);
        case 1060:
            return read_csr(1060);
        case 1061:
            return read_csr(1061);
        case 1062:
            return read_csr(1062);
        case 1063:
            return read_csr(1063);
#endif
    }
    return 0;
}

static void csrw_ss(uint32_t csr_address, uint32_t value) {
    switch (csr_address) {
        case 960:
            write_csr(960, value);
            break;
        case 961:
            write_csr(961, value);
            break;
        case 962:
            write_csr(962, value);
            break;
        case 963:
            write_csr(963, value);
            break;
        case 964:
            write_csr(964, value);
            break;
        case 965:
            write_csr(965, value);
            break;
        case 966:
            write_csr(966, value);
            break;
        case 967:
            write_csr(967, value);
            break;
        case 968:
            write_csr(968, value);
            break;
        case 969:
            write_csr(969, value);
            break;
        case 970:
            write_csr(970, value);
            break;
        case 971:
            write_csr(971, value);
            break;
        case 972:
            write_csr(972, value);
            break;
        case 973:
            write_csr(973, value);
            break;
        case 974:
            write_csr(974, value);
            break;
        case 975:
            write_csr(975, value);
            break;
        case 976:
            write_csr(976, value);
            break;
        case 977:
            write_csr(977, value);
            break;
        case 978:
            write_csr(978, value);
            break;
        case 979:
            write_csr(979, value);
            break;
        case 980:
            write_csr(980, value);
            break;
        case 981:
            write_csr(981, value);
            break;
        case 982:
            write_csr(982, value);
            break;
        case 983:
            write_csr(983, value);
            break;
        case 984:
            write_csr(984, value);
            break;
        case 985:
            write_csr(985, value);
            break;
        case 986:
            write_csr(986, value);
            break;
        case 987:
            write_csr(987, value);
            break;
        case 988:
            write_csr(988, value);
            break;
        case 989:
            write_csr(989, value);
            break;
        case 990:
            write_csr(990, value);
            break;
        case 991:
            write_csr(991, value);
            break;
#ifdef CSR_LONG_ADDR_MODE
        case 992:
            write_csr(992, value);
            break;
        case 993:
            write_csr(993, value);
            break;
        case 994:
            write_csr(994, value);
            break;
        case 995:
            write_csr(995, value);
            break;
        case 996:
            write_csr(996, value);
            break;
        case 997:
            write_csr(997, value);
            break;
        case 998:
            write_csr(998, value);
            break;
        case 999:
            write_csr(999, value);
            break;
        case 1000:
            write_csr(1000, value);
            break;
        case 1001:
            write_csr(1001, value);
            break;
        case 1002:
            write_csr(1002, value);
            break;
        case 1003:
            write_csr(1003, value);
            break;
        case 1004:
            write_csr(1004, value);
            break;
        case 1005:
            write_csr(1005, value);
            break;
        case 1006:
            write_csr(1006, value);
            break;
        case 1007:
            write_csr(1007, value);
            break;
        case 1008:
            write_csr(1008, value);
            break;
        case 1009:
            write_csr(1009, value);
            break;
        case 1010:
            write_csr(1010, value);
            break;
        case 1011:
            write_csr(1011, value);
            break;
        case 1012:
            write_csr(1012, value);
            break;
        case 1013:
            write_csr(1013, value);
            break;
        case 1014:
            write_csr(1014, value);
            break;
        case 1015:
            write_csr(1015, value);
            break;
        case 1016:
            write_csr(1016, value);
            break;
        case 1017:
            write_csr(1017, value);
            break;
        case 1018:
            write_csr(1018, value);
            break;
        case 1019:
            write_csr(1019, value);
            break;
        case 1020:
            write_csr(1020, value);
            break;
        case 1021:
            write_csr(1021, value);
            break;
        case 1022:
            write_csr(1022, value);
            break;
        case 1023:
            write_csr(1023, value);
            break;
        case 1024:
            write_csr(1024, value);
            break;
        case 1025:
            write_csr(1025, value);
            break;
        case 1026:
            write_csr(1026, value);
            break;
        case 1027:
            write_csr(1027, value);
            break;
        case 1028:
            write_csr(1028, value);
            break;
        case 1029:
            write_csr(1029, value);
            break;
        case 1030:
            write_csr(1030, value);
            break;
        case 1031:
            write_csr(1031, value);
            break;
        case 1032:
            write_csr(1032, value);
            break;
        case 1033:
            write_csr(1033, value);
            break;
        case 1034:
            write_csr(1034, value);
            break;
        case 1035:
            write_csr(1035, value);
            break;
        case 1036:
            write_csr(1036, value);
            break;
        case 1037:
            write_csr(1037, value);
            break;
        case 1038:
            write_csr(1038, value);
            break;
        case 1039:
            write_csr(1039, value);
            break;
        case 1040:
            write_csr(1040, value);
            break;
        case 1041:
            write_csr(1041, value);
            break;
        case 1042:
            write_csr(1042, value);
            break;
        case 1043:
            write_csr(1043, value);
            break;
        case 1044:
            write_csr(1044, value);
            break;
        case 1045:
            write_csr(1045, value);
            break;
        case 1046:
            write_csr(1046, value);
            break;
        case 1047:
            write_csr(1047, value);
            break;
        case 1048:
            write_csr(1048, value);
            break;
        case 1049:
            write_csr(1049, value);
            break;
        case 1050:
            write_csr(1050, value);
            break;
        case 1051:
            write_csr(1051, value);
            break;
        case 1052:
            write_csr(1052, value);
            break;
        case 1053:
            write_csr(1053, value);
            break;
        case 1054:
            write_csr(1054, value);
            break;
        case 1055:
            write_csr(1055, value);
            break;
        case 1056:
            write_csr(1056, value);
            break;
        case 1057:
            write_csr(1057, value);
            break;
        case 1058:
            write_csr(1058, value);
            break;
        case 1059:
            write_csr(1059, value);
            break;
        case 1060:
            write_csr(1060, value);
            break;
        case 1061:
            write_csr(1061, value);
            break;
        case 1062:
            write_csr(1062, value);
            break;
        case 1063:
            write_csr(1063, value);
            break;
#endif
    }
}

#endif  // CSR_H
