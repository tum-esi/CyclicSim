
package combinedshapers.inet.linklayer.ieee8021q;

import inet.queueing.contract.IPacketBuffer;
import inet.queueing.contract.IPacketClassifier;
import inet.queueing.contract.IPacketGate;
import inet.queueing.contract.IPacketQueue;
import inet.queueing.contract.IPacketScheduler;
import inet.queueing.gate.GateControlList;
import inet.queueing.queue.CompoundPacketQueueBase;

//
// This module implements the MCQF
//
module Ieee8021qMultiCycleQueueingAndForwarding extends CompoundPacketQueueBase
{
    parameters:
        volatile object cycleType @mutable = default([0]);
        volatile object isOddCycle @mutable = default([false, false]);
        int numBEQueues = default(1);
        int numCSQFGroups = default(1);
        int numCQFGroups = default(2);
        int cqfDisplayOffset = 100 + 375*numCSQFGroups;
        int beDisplayOffset = 100 + 375*numCSQFGroups + 250*numCQFGroups;
        double bitrate @unit(bps);
        bool hasGcl = default(false);
        *.bitrate = default(this.bitrate);
        *.extraLength = default(64b); // overhead for Ethernet PHY header
        *.numBEQueues = default(this.numBEQueues);
        *.cycleType = default(this.cycleType);
        *.numBEQueues = default(this.numBEQueues);
        *.numCSQFGroups = default(this.numCSQFGroups);
        *.numCQFGroups = default(this.numCQFGroups);
    submodules:
        buffer: <default("")> like IPacketBuffer if typename != "" {
            parameters:
                @display("p=100,225");
        }
        gateControlList: GateControlList if hasGcl {
            parameters:
                @display("p=100,350");
        }
        classifier: <default("PCPTrafficClassClassifierMCQF")> like IPacketClassifier {
            parameters:
                @display("p=100,100");
        }
        queue[numCSQFGroups*3+numCQFGroups*2+numBEQueues]: <default("DropTailQueue")> like IPacketQueue {
            parameters:
                bufferModule = default(exists(parent.buffer) ? "^.buffer" : "");
                @display("p=450,100,column,125");
        }
        transmissionGateCSQF[numCSQFGroups*3]: <default("PeriodicGateCSQF")> like IPacketGate {
            parameters:
                @display("p=700,100,column,125");
        }
        transmissionGateCQF[numCQFGroups*2]: <default("PeriodicGateCQF")> like IPacketGate {
            parameters:
                @display("p=700,$cqfDisplayOffset,column,125");
        }
        transmissionGate[numBEQueues]: <default("PeriodicGate")> like IPacketGate {
            parameters:
                @display("p=700,$beDisplayOffset,column,125");
        }
        transmissionSelectionAlgorithm[numCSQFGroups*3+numCQFGroups*2+numBEQueues]: <default("")> like IPacketGate {
            parameters:
                @display("p=500,100,column,125");
        }
        transmissionSelection: <default("PriorityScheduler")> like IPacketScheduler {
            parameters:
                reverseOrder = default(false);
                @display("p=844,100");
        }

    connections:
        in --> { @display("m=w"); } --> classifier.in;
        for i=0..numCSQFGroups*3-1 {
          classifier.out++ --> queue[i].in;
          queue[i].out --> transmissionSelectionAlgorithm[i].in;
          transmissionSelectionAlgorithm[i].out --> transmissionGateCSQF[i].in;
          transmissionGateCSQF[i].out --> transmissionSelection.in++;
        }
        for i=0..numCQFGroups*2-1 {
          classifier.out++ --> queue[i+numCSQFGroups*3].in;
          queue[i+numCSQFGroups*3].out --> transmissionSelectionAlgorithm[i+numCSQFGroups*3].in;
          transmissionSelectionAlgorithm[i+numCSQFGroups*3].out --> transmissionGateCQF[i].in;
          transmissionGateCQF[i].out --> transmissionSelection.in++;
        }
        for i=0..numBEQueues-1 {
          classifier.out++ --> queue[i+numCQFGroups*2+numCSQFGroups*3].in;
          queue[i+numCQFGroups*2+numCSQFGroups*3].out --> transmissionSelectionAlgorithm[i+numCQFGroups*2+numCSQFGroups*3].in;
          transmissionSelectionAlgorithm[i+numCQFGroups*2+numCSQFGroups*3].out --> transmissionGate[i].in;
          transmissionGate[i].out --> transmissionSelection.in++;
          transmissionSelection.out --> { @display("m=e"); } --> out;
        }
}
