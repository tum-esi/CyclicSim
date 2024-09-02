//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//


#ifndef __INET_PERIODICGATE_H
#define __INET_PERIODICGATE_H

#include "inet/common/clock/ClockUserModuleMixin.h"
#include "inet/queueing/base/PacketGateBase.h"

//added by ph
#include "inet/common/ModuleRef.h"
#include "inet/queueing/server/PreemptingServer.h"


namespace inet {

extern template class ClockUserModuleMixin<queueing::PacketGateBase>;

namespace queueing {

class INET_API PeriodicGate : public ClockUserModuleMixin<PacketGateBase>, public cListener
{
  public:
    static simsignal_t guardBandStateChangedSignal;

  protected:

    // ModuleRef<PreemptingServer> preemptingServer;

    enum GBMode // added by ph
    {
        bestCase = 1,//!< bestCase
        worstCase = 0//!< worstCase
    };

    GBMode gbMode; // added by ph choose wether to use maxPacketSize as guardband or respective packet length

    int index = 0;
    // int maxPacketLength = 123; // added by ph
    bool initiallyOpen = false;
    clocktime_t initialOffset;
    clocktime_t offset;
    clocktime_t totalDuration = 0;

    int maxOccuringFrameLength = NaN; // added by ph

    std::vector<clocktime_t> durations;
    bool scheduleForAbsoluteTime = false;
    bool enableImplicitGuardBand = true;
    int openSchedulingPriority = 0;
    int closeSchedulingPriority = 0;

    bool isInGuardBand_ = false;

    ClockEvent *changeTimer = nullptr;
    ClockEvent *guardbandActivationTimer = nullptr;  // added by ph

  protected:
    virtual void initialize(int stage) override;
    virtual void finish() override;
    virtual void handleMessage(cMessage *message) override;
    virtual void handleParameterChange(const char *name) override;
    virtual bool canPacketFlowThrough(Packet *packet) const override;

    virtual void initializeGating();
    virtual void scheduleChangeTimer();
    virtual void processChangeTimer();

    // added by ph
    virtual void scheduleGuardbandActivationTimer(clocktime_t durationUntilGuardband);

    virtual void readDurationsPar();

    virtual void updateIsInGuardBand();

  public:
    virtual ~PeriodicGate() {
        cancelAndDelete(changeTimer); // added by ph // destructor of class for deallocating memory
        cancelAndDelete(guardbandActivationTimer);
    }

    virtual clocktime_t getInitialOffset() const { return initialOffset; }
    virtual bool getInitiallyOpen() const { return initiallyOpen; }
    virtual const std::vector<clocktime_t>& getDurations() const { return durations; }

    virtual bool isInGuardBand() const { return isInGuardBand_; }

    virtual void open() override;
    virtual void close() override;

    virtual void handleCanPushPacketChanged(cGate *gate) override;
    virtual void handleCanPullPacketChanged(cGate *gate) override;

    virtual void testfunction();

};

} // namespace queueing
} // namespace inet

#endif
