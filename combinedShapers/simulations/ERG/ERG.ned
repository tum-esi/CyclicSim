package combinedshapers.simulations.ERG;

import inet.networks.base.TsnNetworkBase;
import inet.node.contract.IEthernetNetworkNode;
import inet.node.ethernet.EthernetLink;
import inet.node.tsn.TsnDevice;
import inet.node.tsn.TsnSwitch;

network ERG extends TsnNetworkBase
{
    parameters:
        *.eth[*].bitrate = default(1Gbps);
        @display("bgb=2139.858,1228.2839");
    submodules:
        //node0_0_13_1: <default("TsnDevice")> like IEthernetNetworkNode {
        //    @display("p=806,569");
        //    gates:
        //        ethg[1];
        //}
        sw_0_8: TsnSwitch {
            @display("p=1294.38,363.52798");
            gates:
                ethg[2];
        }
        sw_0_1: TsnSwitch {
            @display("p=1330.182,594.86395");
            gates:
                ethg[5];
        }
        sw_0_0: TsnSwitch {
            @display("p=1710.2339,765.612");
            gates:
                ethg[2];
        }
        sw_0_2: TsnSwitch {
            @display("p=1511.9459,886.78796");
            gates:
                ethg[4];
        }
        sw_0_4: TsnSwitch {
            @display("p=966.654,853.74");
            gates:
                ethg[5];
        }
        sw_0_5: TsnSwitch {
            @display("p=828.954,594.86395");
            gates:
                ethg[2];
        }
        node0_0_0_6: TsnDevice {
            @display("p=1244.808,82.619995");
            gates:
                ethg[1];
        }
        node0_0_0_3: TsnDevice {
            @display("p=1861.704,1035.504");
            gates:
                ethg[1];
        }
        node0_0_0_7: TsnDevice {
            @display("p=828.954,1131.8939");
            gates:
                ethg[1];
        }
        node0_0_0_9: TsnDevice {
            @display("p=605.88,889.542");
            gates:
                ethg[1];
        }
    connections:
        sw_0_8.ethg[0] <--> EthernetLink <--> node0_0_0_6.ethg[0];
        sw_0_8.ethg[1] <--> EthernetLink <--> sw_0_1.ethg[0];
        sw_0_1.ethg[1] <--> EthernetLink <--> sw_0_0.ethg[0];
        sw_0_1.ethg[2] <--> EthernetLink <--> sw_0_2.ethg[0];
        sw_0_1.ethg[3] <--> EthernetLink <--> sw_0_4.ethg[0];
        sw_0_1.ethg[4] <--> EthernetLink <--> sw_0_5.ethg[0];
        sw_0_0.ethg[1] <--> EthernetLink <--> sw_0_2.ethg[1];
        sw_0_2.ethg[2] <--> EthernetLink <--> node0_0_0_3.ethg[0];
        sw_0_2.ethg[3] <--> EthernetLink <--> sw_0_4.ethg[1];
        sw_0_4.ethg[2] <--> EthernetLink <--> node0_0_0_7.ethg[0];
        sw_0_4.ethg[3] <--> EthernetLink <--> node0_0_0_9.ethg[0];
        sw_0_4.ethg[4] <--> EthernetLink <--> sw_0_5.ethg[1];
}
