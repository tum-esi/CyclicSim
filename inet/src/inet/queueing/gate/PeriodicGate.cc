//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//


#include "inet/queueing/gate/PeriodicGate.h"

// added by ph
#include "inet/common/ModuleAccess.h"
#include "inet/networklayer/common/NetworkInterface.h"
#include "inet/common/Simsignals.h"

namespace inet {
namespace queueing {

Define_Module(PeriodicGate);

simsignal_t PeriodicGate::guardBandStateChangedSignal = registerSignal("guardBandStateChanged");

void PeriodicGate::initialize(int stage)
{
    ClockUserModuleMixin::initialize(stage);
    if (stage == INITSTAGE_LOCAL) {
        initiallyOpen = par("initiallyOpen");
        initialOffset = par("offset");
        readDurationsPar();
        scheduleForAbsoluteTime = par("scheduleForAbsoluteTime");

        enableImplicitGuardBand = par("enableImplicitGuardBand");
        openSchedulingPriority = par("openSchedulingPriority");
        closeSchedulingPriority = par("closeSchedulingPriority");

        maxOccuringFrameLength = par("maxOccuringFrameLength");

        if (strcmp(par("gbMode").stringValue(), "bestCase") == 0)
        {
            gbMode = bestCase;
        }
        else if (strcmp(par("gbMode").stringValue(), "worstCase") == 0)
        {
            gbMode = worstCase;
        }
        else
        {
            throw cRuntimeError("Parameter gbMode of %s is %s and is only allowed to be bestCase or worstCase", getFullPath().c_str(),
                    par("gbMode").stringValue());
        }

        changeTimer = new ClockEvent("ChangeTimer");
        // added by ph
        if (gbMode == worstCase)
            guardbandActivationTimer = new ClockEvent("guardbandActivationTimer");


        WATCH(isInGuardBand_);
        WATCH(gbMode);
        WATCH(totalDuration);
        WATCH(enableImplicitGuardBand);

        // gbMode = bestCase;
    }
    else if (stage == INITSTAGE_QUEUEING)
        initializeGating();
    else if (stage == INITSTAGE_LAST)
        emit(guardBandStateChangedSignal, isInGuardBand_);
}

void PeriodicGate::finish()
{
    emit(guardBandStateChangedSignal, isInGuardBand_);
}

void PeriodicGate::handleParameterChange(const char *name)
{
    // NOTE: parameters are set from the gate schedule configurator modules
    // does this mean: when no "offset" value is set from the configurator module => choose parameter value
    if (!strcmp(name, "offset"))
        initialOffset = par("offset");
    else if (!strcmp(name, "initiallyOpen"))
        initiallyOpen = par("initiallyOpen");
    else if (!strcmp(name, "durations"))
        readDurationsPar();
    initializeGating();
}

void PeriodicGate::handleMessage(cMessage *message)
{
    if (message == changeTimer) {
        scheduleChangeTimer();
        processChangeTimer();
    }
    else if (gbMode == worstCase && message == guardbandActivationTimer){
        updateIsInGuardBand();
        // emit(guardBandStateChangedSignal, true);
    }
    else
        throw cRuntimeError("Unknown message");
}

void PeriodicGate::readDurationsPar()
{
    auto durationsPar = check_and_cast<cValueArray *>(par("durations").objectValue());
    size_t size = durationsPar->size();
    if (size % 2 != 0)
        throw cRuntimeError("The duration parameter must contain an even number of values");
    totalDuration = CLOCKTIME_ZERO;

    durations.resize(size);
    for (size_t i = 0; i < size; i++) {
        clocktime_t duration = durationsPar->get(i).doubleValueInUnit("s");
        if (duration <= CLOCKTIME_ZERO)
            throw cRuntimeError("Unaccepted duration value (%s) at position %zu", durationsPar->get(i).str().c_str(), i);
        durations[i] = duration;
        totalDuration += duration;
    }
}

void PeriodicGate::open()
{
    PacketGateBase::open();
    updateIsInGuardBand();

    if (isOpen_ && !isInGuardBand_) { // (isOpen_ && !initiallyOpen && !isInGuardBand_)
        emit(PacketGateBase::gateTransmissionAllowedStateChangedSignal, true);
        if (producer != nullptr)
            producer->handleCanPushPacketChanged(inputGate->getPathStartGate());
        if (collector != nullptr)
            collector->handleCanPullPacketChanged(outputGate->getPathEndGate());
    }
}

void PeriodicGate::close()
{
    if (enableImplicitGuardBand){
        bool newIsInGuardBand = false;
        if (isInGuardBand_ != newIsInGuardBand) {
            isInGuardBand_ = newIsInGuardBand;
            EV_INFO << "Changing guard band state" << EV_FIELD(isInGuardBand_) << EV_ENDL;
            emit(guardBandStateChangedSignal, isInGuardBand_);
        }
    }
    PacketGateBase::close();
    // updateIsInGuardBand();
}

void PeriodicGate::initializeGating()
{
    index = 0;
    isOpen_ = initiallyOpen;
    offset.setRaw(totalDuration != 0 ? initialOffset.raw() % totalDuration.raw() : 0); //

    while (offset > CLOCKTIME_ZERO) {
        clocktime_t duration = durations[index];
        if (offset >= duration) {
            isOpen_ = !isOpen_;
            offset -= duration;
            index = (index + 1) % durations.size();
        }
        else
            break;
    }
    if (changeTimer->isScheduled())
        cancelClockEvent(changeTimer);

    if (gbMode == worstCase && guardbandActivationTimer->isScheduled()) // added by ph
        cancelClockEvent(guardbandActivationTimer); // added by ph

    if (durations.size() > 0)
        scheduleChangeTimer();
}

void PeriodicGate::scheduleChangeTimer()
{
    ASSERT(0 <= index && (size_t)index < durations.size());
    clocktime_t duration = durations[index];
    index = (index + 1) % durations.size();

    changeTimer->setSchedulingPriority(isOpen_ ? closeSchedulingPriority : openSchedulingPriority);

    if (scheduleForAbsoluteTime){
        scheduleClockEventAt(getClockTime() + duration - offset, changeTimer);
    }
    else{
        scheduleClockEventAfter(duration - offset, changeTimer);
    }

    // added by ph
    if (gbMode == worstCase){
        clocktime_t worstCaseGuardbandDuration = s(static_cast<b>(maxOccuringFrameLength * 8) / bitrate).get(); // transmission time for packet with given length in Byte

        // check if we are in an open gate state (because next gate event will be gate closing event)
        // when the gate is initially OPEN and the index is even => the next gate event will be a CLOSING event
        // 0 ---- 1 ____ 2 ---- 3 ____ ...
        // when the gate is initially CLOSED and the index is uneven => the next gate event will be a CLOSING event
        // 0 ____ 1 ---- 2 ____ 3 ---- ...

        // for AVB GB, we need the uneven indices and gates that are initially closed.
        int oldIndex = (index - 1) % durations.size(); // get old index, because incremented index was before used to schedule next gate closing/(opening)-event
        if (!initiallyOpen && oldIndex % 2 != 0){
            EV_INFO << "Schedule Guardband Change Timer" << EV_ENDL;
            clocktime_t preGuardbandDuration = (duration - offset) - worstCaseGuardbandDuration; // this gets negative, when current point in time is within wc GB duration
            if (preGuardbandDuration > 0) // && preGuardbandDuration <= duration)
                scheduleGuardbandActivationTimer(preGuardbandDuration); // schedule GB within the current gate opening state //
            else
                updateIsInGuardBand();
        }
    }

    offset = 0;
}

void PeriodicGate::processChangeTimer()
{
    EV_INFO << "Processing change timer" << EV_ENDL;
    if (isOpen_)
        close();
    else
        open();
}

// added by ph
void PeriodicGate::scheduleGuardbandActivationTimer(clocktime_t durationUntilGuardband)
{
    ASSERT(gbMode == worstCase && durationUntilGuardband > 0);
    guardbandActivationTimer->setSchedulingPriority(changeTimer->getSchedulingPriority());
    //guardbandActivationTimer->setSchedulingPriority(isOpen_ ? closeSchedulingPriority : openSchedulingPriority);
    if (scheduleForAbsoluteTime)
        scheduleClockEventAt(getClockTime() + durationUntilGuardband, guardbandActivationTimer);
    else
        scheduleClockEventAfter(durationUntilGuardband, guardbandActivationTimer);
}

bool PeriodicGate::canPacketFlowThrough(Packet *packet) const
{
    ASSERT(isOpen_);
    if (std::isnan(bitrate.get()))
        return PacketGateBase::canPacketFlowThrough(packet);
    else if (gbMode == bestCase && packet == nullptr) // (gbMode == bestCase && packet == nullptr)
        return false;
    else {
        if (enableImplicitGuardBand) {
            clocktime_t packetTransmissionDuration = 0;
            if (gbMode == worstCase){
                int overhead = 100; // add overhead to provoke canPacketFlowThrough to return "false" when its called exactly maxOccuringFrameLength Byte/bitrate before gate closing
                // overhead does not change the activation duration before gate closing  it only makes sure that canPacketFlowThrough() turns false reliably
                packetTransmissionDuration = s(static_cast<b>((maxOccuringFrameLength + overhead) * 8) / bitrate).get();
            }
            else if (gbMode == bestCase)
                packetTransmissionDuration = s((packet->getDataLength() + extraLength) / bitrate).get(); // packetTransmissionDuration = s((packet->getDataLength() + extraLength) / bitrate).get();
            else
                throw cRuntimeError("gbMode not defined");

            clocktime_t flowEndTime = getClockTime() + packetTransmissionDuration + SIMTIME_AS_CLOCKTIME(extraDuration);
            return !changeTimer->isScheduled() || flowEndTime <= getArrivalClockTime(changeTimer);
        }
        else
            return PacketGateBase::canPacketFlowThrough(packet);
    }
}

void PeriodicGate::updateIsInGuardBand()
{
    bool newIsInGuardBand = false;
    if (isOpen_) {
        auto packet = provider != nullptr ? provider->canPullPacket(inputGate->getPathStartGate()) : nullptr;
        bool condition1 = (gbMode == worstCase || (gbMode == bestCase && packet != nullptr)); // packet != nullptr; // = (gbMode == worstCase || (gbMode == bestCase && packet != nullptr));
        bool condition2 = !canPacketFlowThrough(packet);
        newIsInGuardBand = condition1 && condition2;
    }
    if (isInGuardBand_ != newIsInGuardBand) {
        isInGuardBand_ = newIsInGuardBand;
        EV_INFO << "Changing guard band state" << EV_FIELD(isInGuardBand_) << EV_ENDL;
        emit(guardBandStateChangedSignal, isInGuardBand_);
        if (!initiallyOpen) { // (!initiallyOpen && false) when "withoutHoldRelease"
            if (isInGuardBand_){
                emit(PacketGateBase::gateTransmissionAllowedStateChangedSignal, false);
            }
        }
    }
}

void PeriodicGate::testfunction()
{
    Enter_Method("testfunction");
    //updateIsInGuardBand();
}

void PeriodicGate::handleCanPushPacketChanged(cGate *gate)
{
    PacketGateBase::handleCanPushPacketChanged(gate);
    updateIsInGuardBand();
}


void PeriodicGate::handleCanPullPacketChanged(cGate *gate)
{
    PacketGateBase::handleCanPullPacketChanged(gate);
    updateIsInGuardBand();
}


} // namespace queueing
} // namespace inet

