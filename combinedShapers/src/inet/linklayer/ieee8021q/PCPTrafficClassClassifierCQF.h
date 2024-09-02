//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//

#ifndef __CQF_FP_PCPTRAFFICCLASSCLASSIFIERCQF_H
#define __CQF_FP_PCPTRAFFICCLASSCLASSIFIERCQF_H

#include "inet/queueing/base/PacketClassifierBase.h"
#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#endif

namespace combinedshapers {

using namespace inet;

#ifdef __linux__
class INET_API PCPTrafficClassClassifierCQF
    : public queueing::PacketClassifierBase
#endif
#ifdef _WIN32
class DLL_EXPORT PCPTrafficClassClassifierCQF
    : public queueing::PacketClassifierBase
#endif
{
protected:
  const char *mode = nullptr;
  cValueArray *mapping = nullptr;
  int defaultGateIndex = -1;
  volatile bool isOddCycle;
  int numBEQueues;

protected:
  virtual void initialize(int stage) override;
  virtual int classifyPacket(Packet *packet) override;
  virtual void handleParameterChange(const char *name) override;
};

} // namespace combinedshapers

#endif
