//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//

#ifndef __CQF_FP_PERIODICGATECSQF_H
#define __CQF_FP_PERIODICGATECSQF_H

#include "inet/queueing/gate/PeriodicGate.h"
#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#endif

namespace combinedshapers {

#ifdef __linux__
class INET_API PeriodicGateCSQF : public inet::queueing::PeriodicGate {
#endif
#ifdef _WIN32
class DLL_EXPORT PeriodicGateCSQF : public inet::queueing::PeriodicGate {
#endif
protected:
  volatile int cycleType;
  int queueIdx;
  bool alwaysOpen = false;

protected:
  virtual void initialize(int stage) override;

  virtual void handleParameterChange(const char *name) override;

  virtual void processChangeTimer() override;

public:

};
} // namespace combinedshapers

#endif



