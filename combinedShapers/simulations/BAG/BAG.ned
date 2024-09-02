package combinedshapers.simulations.BAG;

import inet.networks.base.TsnNetworkBase;
import inet.node.contract.IEthernetNetworkNode;
import inet.node.ethernet.EthernetLink;
import inet.node.tsn.TsnDevice;
import inet.node.tsn.TsnSwitch;

network BAG extends TsnNetworkBase
{
    parameters:
        *.eth[*].bitrate = default(1Gbps);
        @display("bgb=1566.24,1299.1759");
    submodules:
        sw_0_0: TsnSwitch {
            @display("p=1012.032,761.032");
            gates:
                ethg[5];
        }
        sw_0_1: TsnSwitch {
            @display("p=688.74396,761.032");
            gates:
                ethg[3];
        }
        sw_0_2: TsnSwitch {
            @display("p=1188.736,636.536");
            gates:
                ethg[3];
        }
        sw_0_3: TsnSwitch {
            @display("p=664.648,383.52798");
            gates:
                ethg[3];
        }
        sw_0_4: TsnSwitch {
            @display("p=923.68,299.192");
            gates:
                ethg[3];
        }
        sw_0_5: TsnSwitch {
            @display("p=471.87997,582.32");
            gates:
                ethg[5];
        }
        sw_0_6: TsnSwitch {
            @display("p=1122.4719,383.52798");
            gates:
                ethg[5];
        }
        node0_0_0_1: TsnDevice {
            @display("p=578.30396,965.84796");
            gates:
                ethg[1];
        }
        node0_0_0_2: TsnDevice {
            @display("p=1345.36,837.336");
            gates:
                ethg[1];
        }
        node0_0_0_3: TsnDevice {
            @display("p=1377.4879,228.91199");
            gates:
                ethg[1];
        }
        node0_0_0_4: TsnDevice {
            @display("p=512.04,160.64");
            gates:
                ethg[1];
        }
        node0_0_0_5: TsnDevice {
            @display("p=891.552,114.45599");
            gates:
                ethg[1];
        }
    connections:
        sw_0_1.ethg[0] <--> EthernetLink <--> node0_0_0_1.ethg[0];
        sw_0_1.ethg[1] <--> EthernetLink <--> sw_0_5.ethg[0];
        sw_0_1.ethg[2] <--> EthernetLink <--> sw_0_0.ethg[0];
        sw_0_5.ethg[1] <--> EthernetLink <--> sw_0_2.ethg[0];
        sw_0_5.ethg[2] <--> EthernetLink <--> sw_0_6.ethg[0];
        sw_0_5.ethg[3] <--> EthernetLink <--> sw_0_3.ethg[0];
        sw_0_5.ethg[4] <--> EthernetLink <--> sw_0_0.ethg[1];
        sw_0_2.ethg[1] <--> EthernetLink <--> sw_0_6.ethg[1];
        sw_0_6.ethg[2] <--> EthernetLink <--> sw_0_4.ethg[0];
        sw_0_6.ethg[3] <--> EthernetLink <--> sw_0_0.ethg[2];
        sw_0_3.ethg[1] <--> EthernetLink <--> sw_0_0.ethg[3];
        sw_0_4.ethg[1] <--> EthernetLink <--> sw_0_0.ethg[4];
        sw_0_2.ethg[2] <--> EthernetLink <--> node0_0_0_2.ethg[0];
        sw_0_6.ethg[4] <--> EthernetLink <--> node0_0_0_3.ethg[0];
        sw_0_3.ethg[2] <--> EthernetLink <--> node0_0_0_4.ethg[0];
        sw_0_4.ethg[2] <--> EthernetLink <--> node0_0_0_5.ethg[0];
}
