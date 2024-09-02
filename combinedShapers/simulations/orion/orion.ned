package combinedshapers.simulations.orion;

import inet.common.scenario.ScenarioManager;
import inet.networks.base.TsnNetworkBase;
import inet.node.contract.IEthernetNetworkNode;
import inet.node.ethernet.EthernetLink;
import inet.node.tsn.TsnClock;
import inet.node.tsn.TsnDevice;
import inet.node.tsn.TsnSwitch;
import inet.node.ethernet.Eth100M;
import inet.node.ethernet.Eth1G;

network orion extends TsnNetworkBase
{
    parameters:
        @display("bgb=1485,811");
    types:
        channel Eth1G extends inet.node.ethernet.Eth1G
        {
            @display("ls=,3");
        }
    submodules:

        // Node 3
        SW22: TsnSwitch {
            @display("p=1052,653");
            gates:
                ethg[8];
        }

        // Node 4
        ES_SM2CA: TsnDevice {
            @display("p=255,578");
            gates:
                ethg[1];
        }

        // Node 6
        ES_SMRIU2: TsnDevice {
            @display("p=900,68");
            gates:
                ethg[1];
        }

        // Node 7
        ES_FCM2: TsnDevice {
            @display("p=572,656");
            gates:
                ethg[1];
        }

        // Node 12
        ES_LCM1: TsnDevice {
            @display("p=659,113");
            gates:
                ethg[1];
        }

        // Node 18
        ES_BFCU: TsnDevice {
            @display("p=1030,742");
            gates:
                ethg[1];
        }

        // Node 25
        SW42: TsnSwitch {
            @display("p=464,594");
            gates:
                ethg[4];
        }

        // Node 26
        ES_SM1CB: TsnDevice {
            @display("p=236,350");
            gates:
                ethg[1];
        }

        // Node 39
        ES_CMRIU1: TsnDevice {
            @display("p=1132,167");
            gates:
                ethg[1];
        }

        // Node 40
        ES_STARTR2: TsnDevice {
            @display("p=1327,354");
            gates:
                ethg[1];
        }

        // Node 45
        SW7: TsnSwitch {
            @display("p=880,458");
            gates:
                ethg[4];
        }

        // Node 44
        SW52: TsnSwitch {
            @display("p=322,530");
            gates:
                ethg[4];
        }

        // Node 43
        SW11: TsnSwitch {
            @display("p=855,694");
            gates:
                ethg[5];
        }

        // Node 42
        SW14: TsnSwitch {
            @display("p=1289,443");
            gates:
                ethg[4];
        }

        // Node 41
        ES_DU1: TsnDevice {
            @display("p=791,745");
            gates:
                ethg[1];
        }

        // Node 38
        ES_GPS2: TsnDevice {
            @display("p=1372,448");
            gates:
                ethg[1];
        }

        // Node 37
        ES_CM1CA: TsnDevice {
            @display("p=378,141");
            gates:
                ethg[1];
        }

        // Node 36
        ES_CM2CB: TsnDevice {
            @display("p=401,612");
            gates:
                ethg[1];
        }

        // Node 35
        ES_CM2CA: TsnDevice {
            @display("p=437,668");
            gates:
                ethg[1];
        }

        // Node 34
        ES_GPS1: TsnDevice {
            @display("p=1341,519");
            gates:
                ethg[1];
        }

        // Node 33
        ES_CMRIU2: TsnDevice {
            @display("p=1099,706");
            gates:
                ethg[1];
        }

        // Node 32
        ES_MIMU2: TsnDevice {
            @display("p=1390,265");
            gates:
                ethg[1];
        }

        // Node 31
        ES_MIMU1: TsnDevice {
            @display("p=1389,318");
            gates:
                ethg[1];
        }

        // Node 30
        SW32: TsnSwitch {
            @display("p=650,626");
            gates:
                ethg[8];
        }

        // Node 29
        ES_SM1CA: TsnDevice {
            @display("p=267,269");
            gates:
                ethg[1];
        }

        // Node 28
        SW8: TsnSwitch {
            @display("p=594,386");
            gates:
                ethg[4];
        }

        // Node 27
        SW41: TsnSwitch {
            @display("p=434,194");
            gates:
                ethg[4];
        }

        // Node 24
        ES_DU2: TsnDevice {
            @display("p=919,760");
            gates:
                ethg[1];
        }

        // Node 23
        ES_RCM1: TsnDevice {
            @display("p=609,103");
            gates:
                ethg[1];
        }

        // Node 22
        ES_SBAND1: TsnDevice {
            @display("p=1297,704");
            gates:
                ethg[1];
        }

        // Node 21
        SW13: TsnSwitch {
            @display("p=1286,281");
            gates:
                ethg[7];
        }

        // Node 20
        ES_RCM2: TsnDevice {
            @display("p=612,690");
            gates:
                ethg[1];
        }

        // Node 19
        ES_SM2CB: TsnDevice {
            @display("p=270,486");
            gates:
                ethg[1];
        }

        // Node 17
        ES_DU3: TsnDevice {
            @display("p=840,762");
            gates:
                ethg[1];
        }

        // Node 16
        ES_FCM1: TsnDevice {
            @display("p=556,125");
            gates:
                ethg[1];
        }

        // Node 15
        ES_STARTR1: TsnDevice {
            @display("p=1369,204");
            gates:
                ethg[1];
        }

        // Node 14
        ES_SBAND2: TsnDevice {
            @display("p=1354,671");
            gates:
                ethg[1];
        }

        // Node 13
        SW51: TsnSwitch {
            @display("p=303,324");
            gates:
                ethg[4];
        }

        // Node 11
        ES_MIMU3: TsnDevice {
            @display("p=1294,195");
            gates:
                ethg[1];
        }

        // Node 10
        SW21: TsnSwitch {
            @display("p=1082,242");
            gates:
                ethg[7];
        }

        // Node 9
        ES_SMRIU1: TsnDevice {
            @display("p=826,66");
            gates:
                ethg[1];
        }

        // Node 8
        SW6: TsnSwitch {
            @display("p=835,156");
            gates:
                ethg[4];
        }

        // Node 5
        SW31: TsnSwitch {
            @display("p=604,182");
            gates:
                ethg[8];
        }

        // Node 2
        ES_CM1CB: TsnDevice {
            @display("p=446,126");
            gates:
                ethg[1];
        }

        // Node 1
        SW12: TsnSwitch {
            @display("p=1298,625");
            gates:
                ethg[4];
        }

        // Node 0
        ES_LCM2: TsnDevice {
            @display("p=677,713");
            gates:
                ethg[1];
        }

    connections:

        ES_SM2CA.ethg[0] <--> Eth1G <--> SW52.ethg[0];
        SW52.ethg[1] <--> Eth1G <--> SW42.ethg[0];
        SW42.ethg[1] <--> Eth1G <--> SW32.ethg[0];
        SW32.ethg[1] <--> Eth1G <--> SW22.ethg[0];
        SW22.ethg[1] <--> Eth1G <--> SW13.ethg[0];
        SW13.ethg[1] <--> Eth1G <--> ES_STARTR2.ethg[0];
        ES_CM2CA.ethg[0] <--> Eth1G <--> SW42.ethg[2];
        SW32.ethg[2] <--> Eth1G <--> SW6.ethg[0];
        SW6.ethg[1] <--> Eth1G <--> ES_SMRIU1.ethg[0];
        ES_DU3.ethg[0] <--> Eth1G <--> SW11.ethg[0];
        SW11.ethg[1] <--> Eth1G <--> SW22.ethg[2];
        SW42.ethg[3] <--> Eth1G <--> ES_CM2CB.ethg[0];
        ES_SM1CA.ethg[0] <--> Eth1G <--> SW51.ethg[0];
        SW51.ethg[1] <--> Eth1G <--> SW41.ethg[0];
        SW41.ethg[1] <--> Eth1G <--> ES_CM1CB.ethg[0];
        SW51.ethg[2] <--> Eth1G <--> ES_SM1CB.ethg[0];
        SW11.ethg[2] <--> Eth1G <--> SW21.ethg[0];
        SW21.ethg[1] <--> Eth1G <--> SW13.ethg[2];
        SW13.ethg[3] <--> Eth1G <--> ES_STARTR1.ethg[0];
        ES_FCM2.ethg[0] <--> Eth1G <--> SW32.ethg[3];
        SW6.ethg[2] <--> Eth1G <--> SW31.ethg[0];
        SW31.ethg[1] <--> Eth1G <--> SW21.ethg[2];
        SW11.ethg[3] <--> Eth1G <--> ES_DU2.ethg[0];
        ES_DU1.ethg[0] <--> Eth1G <--> SW11.ethg[4];
        SW31.ethg[2] <--> Eth1G <--> SW41.ethg[2];
        SW21.ethg[3] <--> Eth1G <--> SW12.ethg[0];
        SW12.ethg[1] <--> Eth1G <--> ES_SBAND1.ethg[0];
        ES_BFCU.ethg[0] <--> Eth1G <--> SW22.ethg[3];
        SW22.ethg[4] <--> Eth1G <--> SW14.ethg[0];
        SW14.ethg[1] <--> Eth1G <--> ES_GPS1.ethg[0];
        SW31.ethg[3] <--> Eth1G <--> ES_FCM1.ethg[0];
        SW13.ethg[4] <--> Eth1G <--> ES_MIMU2.ethg[0];
        ES_LCM2.ethg[0] <--> Eth1G <--> SW32.ethg[4];
        SW13.ethg[5] <--> Eth1G <--> ES_MIMU1.ethg[0];
        ES_CMRIU2.ethg[0] <--> Eth1G <--> SW22.ethg[5];
        SW22.ethg[6] <--> Eth1G <--> SW7.ethg[0];
        SW7.ethg[1] <--> Eth1G <--> SW31.ethg[4];
        SW31.ethg[5] <--> Eth1G <--> ES_RCM1.ethg[0];
        SW51.ethg[3] <--> Eth1G <--> SW8.ethg[0];
        SW8.ethg[1] <--> Eth1G <--> SW32.ethg[5];
        SW32.ethg[6] <--> Eth1G <--> ES_RCM2.ethg[0];
        ES_CM1CA.ethg[0] <--> Eth1G <--> SW41.ethg[3];
        SW6.ethg[3] <--> Eth1G <--> ES_SMRIU2.ethg[0];
        SW14.ethg[2] <--> Eth1G <--> SW21.ethg[4];
        SW52.ethg[2] <--> Eth1G <--> SW8.ethg[2];
        SW8.ethg[3] <--> Eth1G <--> SW31.ethg[6];
        SW12.ethg[2] <--> Eth1G <--> SW22.ethg[7];
        SW13.ethg[6] <--> Eth1G <--> ES_MIMU3.ethg[0];
        ES_LCM1.ethg[0] <--> Eth1G <--> SW31.ethg[7];
        SW52.ethg[3] <--> Eth1G <--> ES_SM2CB.ethg[0];
        ES_CMRIU1.ethg[0] <--> Eth1G <--> SW21.ethg[5];
        SW21.ethg[6] <--> Eth1G <--> SW7.ethg[2];
        SW7.ethg[3] <--> Eth1G <--> SW32.ethg[7];
        ES_GPS2.ethg[0] <--> Eth1G <--> SW14.ethg[3];
        ES_SBAND2.ethg[0] <--> Eth1G <--> SW12.ethg[3];
}
