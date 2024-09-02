package combinedshapers.simulations.ring;

import inet.networks.base.TsnNetworkBase;
import inet.node.contract.IEthernetNetworkNode;
import inet.node.ethernet.EthernetLink;
import inet.node.tsn.TsnDevice;
import inet.node.tsn.TsnSwitch;

network ring extends TsnNetworkBase
{
    parameters:
        *.eth[*].bitrate = default(100Mbps);
        @display("bgb=997,883");
    submodules:
        sw_0_0: TsnSwitch {
            @display("p=464,420");
            gates:
                ethg[5];
        }
        sw_0_1: TsnSwitch {
            @display("p=319,321");
            gates:
                ethg[4];
        }
        sw_0_7: TsnSwitch {
            @display("p=607,420");
            gates:
                ethg[5];
        }
        sw_0_11: TsnSwitch {
            @display("p=464,492");
            gates:
                ethg[5];
        }
        sw_0_2: TsnSwitch {
            @display("p=319,200");
            gates:
                ethg[4];
        }
        sw_0_6: TsnSwitch {
            @display("p=744,321");
            gates:
                ethg[4];
        }
        sw_0_12: TsnSwitch {
            @display("p=607,492");
            gates:
                ethg[5];
        }
        sw_0_3: TsnSwitch {
            @display("p=464,122");
            gates:
                ethg[4];
        }
        sw_0_4: TsnSwitch {
            @display("p=607,122");
            gates:
                ethg[4];
        }
        sw_0_5: TsnSwitch {
            @display("p=744,200");
            gates:
                ethg[4];
        }
        sw_0_8: TsnSwitch {
            @display("p=464,792");
            gates:
                ethg[4];
        }
        sw_0_9: TsnSwitch {
            @display("p=319,700");
            gates:
                ethg[4];
        }
        sw_0_15: TsnSwitch {
            @display("p=622,792");
            gates:
                ethg[4];
        }
        sw_0_10: TsnSwitch {
            @display("p=319,547");
            gates:
                ethg[2];
        }
        sw_0_14: TsnSwitch {
            @display("p=744,700");
            gates:
                ethg[4];
        }
        sw_0_13: TsnSwitch {
            @display("p=744,569");
            gates:
                ethg[4];
        }
        node0_0_0_0: TsnDevice {
            @display("p=393,420");
            gates:
                ethg[1];
        }
        node0_0_0_1: TsnDevice {
            @display("p=464,348");
            gates:
                ethg[1];
        }
        node0_0_1_0: TsnDevice {
            @display("p=240,321");
            gates:
                ethg[1];
        }
        node0_0_1_1: TsnDevice {
            @display("p=319,400");
            gates:
                ethg[1];
        }
        node0_0_7_0: TsnDevice {
            @display("p=607,348");
            gates:
                ethg[1];
        }
        node0_0_7_1: TsnDevice {
            @display("p=684,420");
            gates:
                ethg[1];
        }
        node0_0_11_0: TsnDevice {
            @display("p=385,492");
            gates:
                ethg[1];
        }
        node0_0_11_1: TsnDevice {
            @display("p=464,575");
            gates:
                ethg[1];
        }
        node0_0_2_0: TsnDevice{
            @display("p=319,131");
            gates:
                ethg[1];
        }
        node0_0_2_1: TsnDevice {
            @display("p=249,200");
            gates:
                ethg[1];
        }
        node0_0_6_0: TsnDevice {
            @display("p=744,400");
            gates:
                ethg[1];
        }
        node0_0_6_1: TsnDevice {
            @display("p=819,321");
            gates:
                ethg[1];
        }
        node0_0_12_0: TsnDevice {
            @display("p=607,569");
            gates:
                ethg[1];
        }
        node0_0_12_1: TsnDevice {
            @display("p=684,492");
            gates:
                ethg[1];
        }
        node0_0_3_0: TsnDevice {
            @display("p=464,192");
            gates:
                ethg[1];
        }
        node0_0_3_1: TsnDevice {
            @display("p=393,122");
            gates:
                ethg[1];
        }
        node0_0_4_0: TsnDevice {
            @display("p=607,192");
            gates:
                ethg[1];
        }
        node0_0_4_1: TsnDevice {
            @display("p=684,122");
            gates:
                ethg[1];
        }
        node0_0_5_0: TsnDevice {
            @display("p=819,200");
            gates:
                ethg[1];
        }
        node0_0_5_1: TsnDevice {
            @display("p=744,131");
            gates:
                ethg[1];
        }
        node0_0_8_0: TsnDevice {
            @display("p=464,860");
            gates:
                ethg[1];
        }
        node0_0_8_1: TsnDevice {
            @display("p=393,792");
            gates:
                ethg[1];
        }
        node0_0_9_0: TsnDevice {
            @display("p=262,700");
            gates:
                ethg[1];
        }
        node0_0_9_1: TsnDevice {
            @display("p=319,777");
            gates:
                ethg[1];
        }
        node0_0_15_0: TsnDevice {
            @display("p=684,792");
            gates:
                ethg[1];
        }
        node0_0_15_1: TsnDevice {
            @display("p=622,860");
            gates:
                ethg[1];
        }
        node0_0_14_0: TsnDevice {
            @display("p=819,700");
            gates:
                ethg[1];
        }
        node0_0_14_1: TsnDevice {
            @display("p=744,777");
            gates:
                ethg[1];
        }
        node0_0_13_0: TsnDevice {
            @display("p=744,500");
            gates:
                ethg[1];
        }
        node0_0_13_1: TsnDevice {
            @display("p=806,569");
            gates:
                ethg[1];
        }
    connections:
        sw_0_0.ethg[0] <--> EthernetLink <--> sw_0_1.ethg[0];
        sw_0_0.ethg[1] <--> EthernetLink <--> sw_0_7.ethg[0];
        sw_0_0.ethg[2] <--> EthernetLink <--> sw_0_11.ethg[0];
        sw_0_0.ethg[3] <--> EthernetLink <--> node0_0_0_0.ethg++;
        sw_0_0.ethg[4] <--> EthernetLink <--> node0_0_0_1.ethg++;
        sw_0_1.ethg[1] <--> EthernetLink <--> sw_0_2.ethg[0];
        sw_0_1.ethg[2] <--> EthernetLink <--> node0_0_1_0.ethg++;
        sw_0_1.ethg[3] <--> EthernetLink <--> node0_0_1_1.ethg++;
        sw_0_7.ethg[1] <--> EthernetLink <--> sw_0_6.ethg[0];
        sw_0_7.ethg[2] <--> EthernetLink <--> sw_0_12.ethg[0];
        sw_0_7.ethg[3] <--> EthernetLink <--> node0_0_7_0.ethg++;
        sw_0_7.ethg[4] <--> EthernetLink <--> node0_0_7_1.ethg++;
        sw_0_11.ethg[1] <--> EthernetLink <--> sw_0_10.ethg[0];
        sw_0_11.ethg[2] <--> EthernetLink <--> sw_0_12.ethg[1];
        sw_0_11.ethg[3] <--> EthernetLink <--> node0_0_11_0.ethg++;
        sw_0_11.ethg[4] <--> EthernetLink <--> node0_0_11_1.ethg++;
        sw_0_2.ethg[1] <--> EthernetLink <--> sw_0_3.ethg[0];
        sw_0_2.ethg[2] <--> EthernetLink <--> node0_0_2_0.ethg++;
        sw_0_2.ethg[3] <--> EthernetLink <--> node0_0_2_1.ethg++;
        sw_0_6.ethg[1] <--> EthernetLink <--> sw_0_5.ethg[0];
        sw_0_6.ethg[2] <--> EthernetLink <--> node0_0_6_0.ethg++;
        sw_0_6.ethg[3] <--> EthernetLink <--> node0_0_6_1.ethg++;
        sw_0_12.ethg[2] <--> EthernetLink <--> sw_0_13.ethg[0];
        sw_0_12.ethg[3] <--> EthernetLink <--> node0_0_12_0.ethg++;
        sw_0_12.ethg[4] <--> EthernetLink <--> node0_0_12_1.ethg++;
        sw_0_3.ethg[1] <--> EthernetLink <--> sw_0_4.ethg[0];
        sw_0_3.ethg[2] <--> EthernetLink <--> node0_0_3_0.ethg++;
        sw_0_3.ethg[3] <--> EthernetLink <--> node0_0_3_1.ethg++;
        sw_0_4.ethg[1] <--> EthernetLink <--> sw_0_5.ethg[1];
        sw_0_4.ethg[2] <--> EthernetLink <--> node0_0_4_0.ethg++;
        sw_0_4.ethg[3] <--> EthernetLink <--> node0_0_4_1.ethg++;
        sw_0_5.ethg[2] <--> EthernetLink <--> node0_0_5_0.ethg++;
        sw_0_5.ethg[3] <--> EthernetLink <--> node0_0_5_1.ethg++;
        sw_0_8.ethg[0] <--> EthernetLink <--> sw_0_9.ethg[0];
        sw_0_8.ethg[1] <--> EthernetLink <--> sw_0_15.ethg[0];
        sw_0_8.ethg[2] <--> EthernetLink <--> node0_0_8_0.ethg++;
        sw_0_8.ethg[3] <--> EthernetLink <--> node0_0_8_1.ethg++;
        sw_0_9.ethg[1] <--> EthernetLink <--> sw_0_10.ethg[1];
        sw_0_9.ethg[2] <--> EthernetLink <--> node0_0_9_0.ethg++;
        sw_0_9.ethg[3] <--> EthernetLink <--> node0_0_9_1.ethg++;
        sw_0_15.ethg[1] <--> EthernetLink <--> sw_0_14.ethg[0];
        sw_0_15.ethg[2] <--> EthernetLink <--> node0_0_15_0.ethg++;
        sw_0_15.ethg[3] <--> EthernetLink <--> node0_0_15_1.ethg++;
        sw_0_14.ethg[1] <--> EthernetLink <--> sw_0_13.ethg[1];
        sw_0_14.ethg[2] <--> EthernetLink <--> node0_0_14_0.ethg++;
        sw_0_14.ethg[3] <--> EthernetLink <--> node0_0_14_1.ethg++;
        sw_0_13.ethg[3] <--> EthernetLink <--> node0_0_13_1.ethg++;
        sw_0_13.ethg[2] <--> EthernetLink <--> node0_0_13_0.ethg++;
}
