//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//


package inet.linklayer.ethernet.modular;

import inet.linklayer.ethernet.contract.IEthernetMacLayer;
import inet.protocolelement.contract.IPacketLifeTimer;

import inet.queueing.classifier.PacketClassifier;
import inet.queueing.contract.IPacketClassifier;
import inet.linklayer.ieee8021q.PcpTrafficClassClassifier;
import inet.queueing.classifier.PriorityClassifier;

import inet.queueing.common.PacketMultiplexer;
import inet.queueing.contract.IPacketQueue;
import inet.queueing.scheduler.PriorityScheduler;
import inet.queueing.server.PreemptingServer;

import inet.queueing.contract.IPacketServer; // added by ph

module EthernetPreemptingMacLayer like IEthernetMacLayer
{
    parameters:
        volatile double bitrate @unit(bps);
                
        *.bitrate = default(this.bitrate);
        lifetimer.collectionModule = default("^.queue");
        @display("i=block/layer");
    gates:
        input upperLayerIn;
        output upperLayerOut;
        input lowerLayerIn;
        output lowerLayerOut;
    submodules:
        lifetimer: <default("")> like IPacketLifeTimer if typename != "" {
            @display("p=100,100;is=s");
        }
        queue: <default("")> like IPacketQueue {
            @display("p=200,51");
        }

//        outboundClassifier: PacketClassifier {
//            classifierClass = default("inet::PacketVlanReqClassifier");
//            @display("p=200,200");
//        }

//        outboundClassifier: <default("PcpTrafficClassClassifier")> like IPacketClassifier {
//			@display("p=200,247");
//        }
        
        outboundClassifier: <default("PacketClassifier")> like IPacketClassifier {
            classifierClass = default("inet::PacketVlanReqClassifier");
            @display("p=200,200");
        }

        expressMacLayer: <default("EthernetStreamingMacLayer")> like IEthernetMacLayer {
            @display("p=300,347");
        }
        preemptableMacLayer: <default("EthernetFragmentingMacLayer")> like IEthernetMacLayer {
            //@display("p=500,347");
        }
        scheduler: PriorityScheduler {
            @display("p=200,400");
        }
        preemptingServer: PreemptingServer {
            datarate = default(parent.bitrate);
            @display("p=200,547");
        }
        inboundClassifier: PacketClassifier {
            classifierClass = default("inet::PacketFragmentTagClassifier");
            @display("p=600,447");
        }
        multiplexer: PacketMultiplexer {
            @display("p=600,247");
        }
    connections:
        upperLayerIn --> { @display("m=n"); } --> queue.in;
        queue.out --> outboundClassifier.in;
		outboundClassifier.out++ --> expressMacLayer.upperLayerIn;
    	outboundClassifier.out++ --> preemptableMacLayer.upperLayerIn;
        expressMacLayer.lowerLayerOut --> scheduler.in++;
        preemptableMacLayer.lowerLayerOut --> scheduler.in++;
        scheduler.out --> preemptingServer.in;
        preemptingServer.out --> { @display("m=s"); } --> lowerLayerOut;
        lowerLayerIn --> { @display("m=s"); } --> inboundClassifier.in;
        inboundClassifier.out++ --> expressMacLayer.lowerLayerIn;
        inboundClassifier.out++ --> preemptableMacLayer.lowerLayerIn;
        expressMacLayer.upperLayerOut --> multiplexer.in++;
        preemptableMacLayer.upperLayerOut --> multiplexer.in++;
        multiplexer.out --> { @display("m=n"); } --> upperLayerOut;
}
