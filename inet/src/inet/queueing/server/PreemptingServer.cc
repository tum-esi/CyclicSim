//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//


#include "inet/queueing/server/PreemptingServer.h"
#include "inet/common/Simsignals.h" // added by ph



namespace inet {
namespace queueing {

Define_Module(PreemptingServer);

void PreemptingServer::initialize(int stage)
{
    ClockUserModuleMixin::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        datarate = bps(par("datarate"));
        timer = new ClockEvent("Timer");

//        // added by ph
//        holdRelease = ;
//        if (par("preemptionMode") == "withHoldRelease")
//            preemptionMode = withHoldRelease;
//        else if (par("preemptionMode") == "withoutHoldRelease")
//            preemptionMode = withoutHoldRelease;


        if (strcmp(par("preemptionMode").stringValue(), "withHoldRelease") == 0)
        {
            preemptionMode = withHoldRelease;
        }
        else if (strcmp(par("preemptionMode").stringValue(), "withoutHoldRelease") == 0)
        {
            preemptionMode = withoutHoldRelease;
        }
        else
        {
            throw cRuntimeError("Parameter preemptionMode of %s is %s and is only allowed to be withHoldRelease or withoutHoldRelease", getFullPath().c_str(),
                    par("preemptionMode").stringValue());
        }

        cModule *module = this->getParentModule()->getSubmodule("preemptableMacLayer")->getSubmodule("queue")->getSubmodule("transmissionGate",0);
        if (module != nullptr && preemptionMode == withHoldRelease){
            module->subscribe(PeriodicGate::guardBandStateChangedSignal, this);
            moduleFound = true;
        }
        else
            moduleFound = false;

        WATCH(isInGuardband_);
        WATCH(isBlocked_);

        WATCH(moduleFound);
    }
}

void PreemptingServer::handleMessage(cMessage *message)
{
    if (message == timer)
        endStreaming();
    else
        PacketServerBase::handleMessage(message);
}

bool PreemptingServer::canStartStreaming() const
{
    return provider->canPullSomePacket(inputGate->getPathStartGate()) && consumer->canPushSomePacket(outputGate->getPathEndGate());
}

void PreemptingServer::startStreaming()
{

    auto packet = provider->pullPacketStart(inputGate->getPathStartGate(), datarate);
    take(packet);
    EV_INFO << "Starting streaming packet" << EV_FIELD(packet) << EV_ENDL;
    streamedPacket = packet;
    pushOrSendPacketStart(streamedPacket->dup(), outputGate, consumer, datarate, packet->getTransmissionId());
    scheduleClockEventAfter(s(streamedPacket->getTotalLength() / datarate).get(), timer);
    handlePacketProcessed(streamedPacket);
    updateDisplayString();
}

void PreemptingServer::endStreaming()
{
    auto packet = provider->pullPacketEnd(inputGate->getPathStartGate());
    take(packet);
    delete streamedPacket;
    streamedPacket = packet;
    EV_INFO << "Ending streaming packet" << EV_FIELD(packet, *streamedPacket) << EV_ENDL;
    pushOrSendPacketEnd(streamedPacket, outputGate, consumer, packet->getTransmissionId());
    streamedPacket = nullptr;
    updateDisplayString();
}

// added by ph
void PreemptingServer::receiveSignal(cComponent *source, simsignal_t signal, bool value, cObject *details)
{
    if (preemptionMode == withHoldRelease){
        bool newIsInGuardband = false;
        Enter_Method("%s", cComponent::getSignalName(signal));
        if (signal == PeriodicGate::guardBandStateChangedSignal) {
            EV_INFO << "Processing received guard band state changed signal" << EV_ENDL;
            if (value != newIsInGuardband){
                newIsInGuardband = value;
                interruptStreaming();
                isBlocked_ = value;
            }
            else
                isBlocked_ = false;
        }
        else
            throw cRuntimeError("Unknown signal");
    }
}

void PreemptingServer::handleCanPushPacketChanged(cGate *gate)
{
    Enter_Method("handleCanPushPacketChanged");
    if (!isStreaming() && canStartStreaming() && !isBlocked_)
        startStreaming();
}

void PreemptingServer::handleCanPullPacketChanged(cGate *gate)
{
    Enter_Method("handleCanPullPacketChanged");
    if (isStreaming()) {
        endStreaming();
        cancelClockEvent(timer);
    }
    else if (canStartStreaming() && !isBlocked_)
        startStreaming();
}

void PreemptingServer::handlePushPacketProcessed(Packet *packet, cGate *gate, bool successful)
{
    Enter_Method("handlePushPacketProcessed");
    if (isStreaming()) {
        delete streamedPacket;
        streamedPacket = provider->pullPacketEnd(inputGate->getPathStartGate());
        take(streamedPacket);
        EV_INFO << "Ending streaming packet" << EV_FIELD(packet, *streamedPacket) << EV_ENDL;
        delete streamedPacket;
        streamedPacket = nullptr;
    }
}

void PreemptingServer::interruptStreaming()
{
    Enter_Method("interruptStreaming");
    if (isStreaming()) {
        endStreaming();
        cancelClockEvent(timer);
    }
}

} // namespace queueing
} // namespace inet

