//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//

#ifndef __CQF_FP_PCPTRAFFICCLASSCLASSIFIERMCQF_H
#define __CQF_FP_PCPTRAFFICCLASSCLASSIFIERMCQF_H

#include "inet/queueing/base/PacketClassifierBase.h"
#include <omnetpp/cvaluearray.h>
#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#endif

namespace combinedshapers {

using namespace inet;

#ifdef __linux__
class INET_API PCPTrafficClassClassifierMCQF
    : public queueing::PacketClassifierBase
#endif
#ifdef _WIN32
class DLL_EXPORT PCPTrafficClassClassifierMCQF
    : public queueing::PacketClassifierBase
#endif
{
protected:
  const char *mode = nullptr;
  cValueArray *mapping = nullptr;
  int defaultGateIndex = -1;
  omnetpp::cValueArray *cycleType = nullptr;
  omnetpp::cValueArray *isOddCycle = nullptr;
  int numCQFGroups;
  int numCSQFGroups;
  int numBEQueues;

protected:
  virtual void initialize(int stage) override;
  virtual int classifyPacket(Packet *packet) override;
  virtual void handleParameterChange(const char *name) override;
};

} // namespace combinedshapers

#endif
