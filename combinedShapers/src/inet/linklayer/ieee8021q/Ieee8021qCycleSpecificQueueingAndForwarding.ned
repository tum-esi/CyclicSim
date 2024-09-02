
package combinedshapers.inet.linklayer.ieee8021q;

import inet.queueing.contract.IPacketBuffer;
import inet.queueing.contract.IPacketClassifier;
import inet.queueing.contract.IPacketGate;
import inet.queueing.contract.IPacketQueue;
import inet.queueing.contract.IPacketScheduler;
import inet.queueing.gate.GateControlList;
import inet.queueing.queue.CompoundPacketQueueBase;

//
// This module implements the CSQF
//
module Ieee8021qCycleSpecificQueueingAndForwarding extends CompoundPacketQueueBase
{
    parameters:
        int numBEQueues = default(1);
        volatile int cycleType @mutable = default(0);
        double bitrate @unit(bps);
        bool hasGcl = default(false);
        *.bitrate = default(this.bitrate);
        *.extraLength = default(64b); // overhead for Ethernet PHY header
        *.numBEQueues = default(this.numBEQueues);
        *.cycleType = default(this.cycleType);
    submodules:
        buffer: <default("")> like IPacketBuffer if typename != "" {
            parameters:
                @display("p=100,225");
        }
        gateControlList: GateControlList if hasGcl {
            parameters:
                @display("p=300,225");
        }
        classifier: <default("PCPTrafficClassClassifierCSQF")> like IPacketClassifier {
            parameters:
                @display("p=100,100");
        }
        queue[numBEQueues + 3]: <default("DropTailQueue")> like IPacketQueue {
            parameters:
                bufferModule = default(exists(parent.buffer) ? "^.buffer" : "");
                @display("p=288,100,column,125");
        }
        transmissionSelectionAlgorithm[numBEQueues + 3]: <default("")> like IPacketGate {
            parameters:
                @display("p=500,100,column,125");
        }
        transmissionGate[numBEQueues + 3]: <default("PeriodicGateCSQF")> like IPacketGate {
            parameters:
                @display("p=700,100,column,125");
        }
        transmissionSelection: <default("PriorityScheduler")> like IPacketScheduler {
            parameters:
                reverseOrder = default(true);
                @display("p=844,100");
        }

    connections:
        in --> { @display("m=w"); } --> classifier.in;
        for i=0..numBEQueues + 2 {
            classifier.out++ --> queue[i].in;
            queue[i].out --> transmissionSelectionAlgorithm[i].in;
            transmissionSelectionAlgorithm[i].out --> transmissionGate[i].in;
            transmissionGate[i].out --> transmissionSelection.in++;
        }
        transmissionSelection.out --> { @display("m=e"); } --> out;
}