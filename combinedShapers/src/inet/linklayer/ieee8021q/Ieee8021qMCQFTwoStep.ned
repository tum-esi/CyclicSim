
package combinedshapers.inet.linklayer.ieee8021q;

import inet.queueing.contract.IPacketBuffer;
import inet.queueing.contract.IPacketClassifier;
import inet.queueing.contract.IPacketGate;
import inet.queueing.contract.IPacketQueue;
import inet.queueing.contract.IPacketScheduler;
import inet.queueing.gate.GateControlList;
import inet.queueing.queue.CompoundPacketQueueBase;

//
// This module implements the Multi-CQF with two step classifier
//
module Ieee8021qMCQFTwoStep extends CompoundPacketQueueBase
{
    parameters:
        volatile object cycleType @mutable = default([0]);
        volatile object isOddCycle @mutable = default([false, false]);
        int numBEQueues = default(1);
        int numCSQFGroups = default(1);
        int numCQFGroups = default(2);
        bool numBEGroups = this.numBEQueues > 0;
        int cqfDisplayOffset = 100 + 375*numCSQFGroups;
        int beDisplayOffset = 100 + 375*numCSQFGroups + 250*numCQFGroups;
        double bitrate @unit(bps);
        *.bitrate = default(this.bitrate);
        *.extraLength = default(64b); // overhead for Ethernet PHY header
        *.groupNumber = numCSQFGroups + numCQFGroups;
        *.numBEQueues = default(this.numBEQueues);
        *.numCSQFGroups = default(this.numCSQFGroups);
        *.numCQFGroups = default(this.numCQFGroups);
    submodules:
        buffer: <default("")> like IPacketBuffer if typename != "" {
            parameters:
                @display("p=100,225");
        }
        groupClassifier: <default("GroupClassifier")> like IPacketClassifier {
            parameters:
                @display("p=100,475");
        }
        CSQFClassifier[numCSQFGroups]: <default("PCPTrafficClassClassifierCSQF")> like IPacketClassifier {
            parameters:
                @display("p=250,250,column,375");
        }
        CQFClassifier[numCQFGroups]: <default("PCPTrafficClassClassifierCQF")> like IPacketClassifier {
            parameters:
                @display("p=250,$cqfDisplayOffset,column,250");
        }
        classifier: <default("PcpTrafficClassClassifier")> like IPacketClassifier if numBEGroups {
            parameters:
                @display("p=250,$beDisplayOffset,column,250");
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
                @display("p=900,475");
        }

    connections:
        in --> { @display("m=w"); } --> groupClassifier.in;

        for i=0..numCSQFGroups-1 {
            groupClassifier.out++ --> CSQFClassifier[i].in;
        }
        for i=0..numCQFGroups-1 {
            groupClassifier.out++ --> CQFClassifier[i].in;
        }
        if numBEGroups {
            groupClassifier.out++ --> classifier.in;
        }

        for i=0..numCSQFGroups-1 {
          CSQFClassifier[i].out++ --> queue[3*i].in;
          CSQFClassifier[i].out++ --> queue[3*i+1].in;
          CSQFClassifier[i].out++ --> queue[3*i+2].in;
          queue[3*i].out   --> transmissionSelectionAlgorithm[3*i].in;
          queue[3*i+1].out --> transmissionSelectionAlgorithm[3*i+1].in;
          queue[3*i+2].out --> transmissionSelectionAlgorithm[3*i+2].in;
          transmissionSelectionAlgorithm[3*i].out   --> transmissionGateCSQF[3*i].in;
          transmissionSelectionAlgorithm[3*i+1].out --> transmissionGateCSQF[3*i+1].in;
          transmissionSelectionAlgorithm[3*i+2].out --> transmissionGateCSQF[3*i+2].in;
          transmissionGateCSQF[3*i].out   --> transmissionSelection.in++;
          transmissionGateCSQF[3*i+1].out --> transmissionSelection.in++;
          transmissionGateCSQF[3*i+2].out --> transmissionSelection.in++;
        }

        for i=0..numCQFGroups-1 {
          CQFClassifier[i].out++ --> queue[2*i+3*numCSQFGroups].in;
          CQFClassifier[i].out++ --> queue[2*i+3*numCSQFGroups+1].in;
          queue[2*i+3*numCSQFGroups].out   --> transmissionSelectionAlgorithm[2*i+3*numCSQFGroups].in;
          queue[2*i+3*numCSQFGroups+1].out --> transmissionSelectionAlgorithm[2*i+3*numCSQFGroups+1].in;
          transmissionSelectionAlgorithm[2*i+3*numCSQFGroups].out   --> transmissionGateCQF[2*i].in;
          transmissionSelectionAlgorithm[2*i+3*numCSQFGroups+1].out --> transmissionGateCQF[2*i+1].in;
          transmissionGateCQF[2*i].out --> transmissionSelection.in++;
          transmissionGateCQF[2*i+1].out --> transmissionSelection.in++;
        }

        for i=3*numCSQFGroups+2*numCQFGroups..3*numCSQFGroups+2*numCQFGroups+numBEQueues-1 {
          classifier.out++ -->queue[i].in;
          queue[i].out --> transmissionSelectionAlgorithm[i].in;
          transmissionSelectionAlgorithm[i].out --> transmissionGate[i-3*numCSQFGroups-2*numCQFGroups].in;
          transmissionGate[i-3*numCSQFGroups-2*numCQFGroups].out --> transmissionSelection.in++;
        }

        transmissionSelection.out --> { @display("m=e"); } --> out;
}

