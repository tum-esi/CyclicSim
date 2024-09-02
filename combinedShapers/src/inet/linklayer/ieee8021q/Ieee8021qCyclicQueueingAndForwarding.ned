
package combinedshapers.inet.linklayer.ieee8021q;

import inet.queueing.contract.IPacketBuffer;
import inet.queueing.contract.IPacketClassifier;
import inet.queueing.contract.IPacketGate;
import inet.queueing.contract.IPacketQueue;
import inet.queueing.contract.IPacketScheduler;
import inet.queueing.gate.GateControlList;
import inet.queueing.queue.CompoundPacketQueueBase;

module Ieee8021qCyclicQueueingAndForwarding extends CompoundPacketQueueBase
{
    parameters:
        int numBEQueues = default(1);
        int num_CQF_Queues = default(2);
        volatile bool isOddCycle @mutable = default(false);
        //object durations @mutable @unit(s) = default([1000us, 1000us]);
        // int numTrafficClasses = default(8); // number of traffic categories
        double bitrate @unit(bps);
        *.bitrate = default(this.bitrate);
        *.extraLength = default(64b); // overhead for Ethernet PHY header
        *.numBEQueues = default(this.numBEQueues);
        *.isOddCycle = default(this.isOddCycle);
        *.offset = default(0s);

        // gcl parameters
        bool hasGcl = default(false); // if using Gcl
        //*.durations = default(dup(this.durations));
        //*.gateStates = default(["101","011"]); // list of gateStates. E.g., ["10000000", "01111111", "10000000", "01111111"]
        //gateControlList.mapping = default("012");
        //*.numGates = default(3);
    submodules:
        buffer: <default("")> like IPacketBuffer if typename != "" {
            parameters:
                @display("p=100,225");
        }
        gateControlList: GateControlList if hasGcl {
            parameters:
                @display("p=300,225");
        }
        classifier: <default("PCPTrafficClassClassifierCQF")> like IPacketClassifier {
            parameters:
                @display("p=100,100");
        }
        queue[numBEQueues + num_CQF_Queues]: <default("DropTailQueue")> like IPacketQueue {
            parameters:
                bufferModule = default(exists(parent.buffer) ? "^.buffer" : "");
                @display("p=288,100,column,125");
        }
        transmissionSelectionAlgorithm[numBEQueues + num_CQF_Queues]: <default("")> like IPacketGate {
            parameters:
                @display("p=500,100,column,125");
        }
        transmissionGate[numBEQueues + num_CQF_Queues]: <default("PeriodicGateCQF")> like IPacketGate {
            parameters:
                @display("p=700,100,column,125");
        }
        transmissionSelection: <default("PriorityScheduler")> like IPacketScheduler {
            parameters:
                reverseOrder = default(false);
                @display("p=844,100");
        }

    connections:
        in --> { @display("m=w"); } --> classifier.in;
        for i=0..numBEQueues + num_CQF_Queues - 1 {
            classifier.out++ --> queue[i].in;
            queue[i].out --> transmissionSelectionAlgorithm[i].in;
            transmissionSelectionAlgorithm[i].out --> transmissionGate[i].in;
            transmissionGate[i].out --> transmissionSelection.in++;
        }
        transmissionSelection.out --> { @display("m=e"); } --> out;
}