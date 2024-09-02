package combinedshapers.simulations.OneSwitch;

import inet.networks.base.TsnNetworkBase;
import inet.node.contract.IEthernetNetworkNode;
import inet.node.ethernet.EthernetLink;
import inet.node.tsn.TsnDevice;
import inet.node.tsn.TsnSwitch;

network oneswitch extends TsnNetworkBase
{
    parameters:
        *.eth[*].bitrate = default(1Gbps);
        @display("bgb=2208.44,1351.3337");
    submodules:
        sw_0_1: TsnSwitch {
            @display("p=1044.1112,396.2725");
            gates:
                ethg[3];
        }
        node0_0_0_1: TsnDevice {
            @display("p=643.3862,598.86127");
            gates:
                ethg[1];
        }
        node0_0_0_2: TsnDevice {
            @display("p=643.3862,233.75626");
            gates:
                ethg[1];
        }
        node0_0_0_3: TsnDevice {
            @display("p=1484.9088,398.49875");
            gates:
                ethg[1];
        }
    connections:
        sw_0_1.ethg[0] <--> EthernetLink <--> node0_0_0_1.ethg[0];
        sw_0_1.ethg[1] <--> EthernetLink <--> node0_0_0_2.ethg[0];
        sw_0_1.ethg[2] <--> EthernetLink <--> node0_0_0_3.ethg[0];
}
