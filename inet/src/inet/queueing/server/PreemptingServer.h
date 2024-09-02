//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//


#ifndef __INET_PREEMPTINGSERVER_H
#define __INET_PREEMPTINGSERVER_H

#include "inet/common/clock/ClockUserModuleMixin.h"
#include "inet/queueing/base/PacketServerBase.h"

#include "inet/common/ModuleRef.h" // added by ph
#include "inet/queueing/gate/PeriodicGate.h" // added by ph

namespace inet {

extern template class ClockUserModuleMixin<queueing::PacketServerBase>;

namespace queueing {

using namespace inet::queueing;

class INET_API PreemptingServer : public ClockUserModuleMixin<PacketServerBase>, public cListener
{
  protected:
    bps datarate = bps(NaN);
    Packet *streamedPacket = nullptr;
    ClockEvent *timer = nullptr;

    enum PreemptionMode // added by ph
    {
        withoutHoldRelease, //!< without HOLD/RELEASE
        withHoldRelease     //!< with HOLD/RELEASE
    };
    PreemptionMode preemptionMode;
    bool isInGuardband_ = false;
    bool isBlocked_ = false;
    bool holdRelease = false;
    bool moduleFound = false;

  protected:
    virtual void initialize(int stage) override;
    virtual void handleMessage(cMessage *message) override;

    virtual bool isStreaming() const { return streamedPacket != nullptr; }
    virtual bool canStartStreaming() const;

    virtual void startStreaming();
    virtual void endStreaming();

  public:
    virtual ~PreemptingServer() { delete streamedPacket; cancelAndDeleteClockEvent(timer); }

    virtual void receiveSignal(cComponent *source, simsignal_t signal, bool value, cObject *details) override; // added by ph

    virtual void handleCanPushPacketChanged(cGate *gate) override;
    virtual void handleCanPullPacketChanged(cGate *gate) override;

    virtual void handlePushPacketProcessed(Packet *packet, cGate *gate, bool successful) override;

    virtual void interruptStreaming();
};

} // namespace queueing
} // namespace inet

#endif

