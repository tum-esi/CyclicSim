package combinedshapers.simulations.RRG;

import inet.networks.base.TsnNetworkBase;
import inet.node.contract.IEthernetNetworkNode;
import inet.node.ethernet.EthernetLink;
import inet.node.tsn.TsnDevice;
import inet.node.tsn.TsnSwitch;

network RRG extends TsnNetworkBase
{
    parameters:
        *.eth[*].bitrate = default(1Gbps);
        @display("bgb=1484.838,904.74");
    submodules:
        sw_0_0: TsnSwitch {
            @display("p=968.60394,743.30597");
            gates:
                ethg[4];
        }
        sw_0_1: TsnSwitch {
            @display("p=361.896,512.686");
            gates:
                ethg[4];
        }
        sw_0_2: TsnSwitch {
            @display("p=1106.976,613.80396");
            gates:
                ethg[5];
        }
        sw_0_3: TsnSwitch {
            @display("p=1085.688,423.986");
            gates:
                ethg[5];
        }
        sw_0_4: TsnSwitch {
            @display("p=780.56,613.80396");
            gates:
                ethg[4];
        }
        sw_0_5: TsnSwitch {
            @display("p=879.904,354.8");
            gates:
                ethg[5];
        }
        sw_0_6: TsnSwitch {
            @display("p=558.81,698.956");
            gates:
                ethg[5];
        }
        sw_0_7: TsnSwitch {
            @display("p=617.352,354.8");
            gates:
                ethg[5];
        }
        node0_0_0_1: TsnDevice {
            @display("p=406.246,798.3");
            gates:
                ethg[1];
        }
        node0_0_0_2: TsnDevice {
            @display("p=1310.986,729.11395");
            gates:
                ethg[1];
        }
        node0_0_0_3: TsnDevice {
            @display("p=780.56,184.49599");
            gates:
                ethg[1];
        }
        node0_0_0_4: TsnDevice {
            @display("p=1286.1499,253.68199");
            gates:
                ethg[1];
        }
        node0_0_0_5: TsnDevice {
            @display("p=464.788,198.68799");
            gates:
                ethg[1];
        }
    connections:
        sw_0_6.ethg[0] <--> EthernetLink <--> node0_0_0_1.ethg[0];
        sw_0_6.ethg[1] <--> EthernetLink <--> sw_0_4.ethg[0];
        sw_0_6.ethg[2] <--> EthernetLink <--> sw_0_0.ethg[0];
        sw_0_6.ethg[3] <--> EthernetLink <--> sw_0_1.ethg[0];
        sw_0_6.ethg[4] <--> EthernetLink <--> sw_0_7.ethg[0];
        sw_0_4.ethg[1] <--> EthernetLink <--> sw_0_2.ethg[0];
        sw_0_4.ethg[2] <--> EthernetLink <--> sw_0_0.ethg[1];
        sw_0_4.ethg[3] <--> EthernetLink <--> sw_0_7.ethg[1];
        sw_0_2.ethg[1] <--> EthernetLink <--> node0_0_0_2.ethg[0];
        sw_0_2.ethg[2] <--> EthernetLink <--> sw_0_5.ethg[0];
        sw_0_2.ethg[3] <--> EthernetLink <--> sw_0_3.ethg[0];
        sw_0_2.ethg[4] <--> EthernetLink <--> sw_0_1.ethg[1];
        sw_0_5.ethg[1] <--> EthernetLink <--> node0_0_0_3.ethg[0];
        sw_0_5.ethg[2] <--> EthernetLink <--> sw_0_3.ethg[1];
        sw_0_5.ethg[3] <--> EthernetLink <--> sw_0_7.ethg[2];
        sw_0_5.ethg[4] <--> EthernetLink <--> sw_0_0.ethg[2];
        sw_0_3.ethg[2] <--> EthernetLink <--> node0_0_0_4.ethg[0];
        sw_0_3.ethg[3] <--> EthernetLink <--> sw_0_1.ethg[2];
        sw_0_3.ethg[4] <--> EthernetLink <--> sw_0_0.ethg[3];
        sw_0_7.ethg[3] <--> EthernetLink <--> node0_0_0_5.ethg[0];
        sw_0_7.ethg[4] <--> EthernetLink <--> sw_0_1.ethg[3];
}
