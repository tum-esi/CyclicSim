//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//

#ifndef __CYCLICSHAPER_PERIODICGATECQF_H
#define __CYCLICSHAPER_PERIODICGATECQF_H

#include "inet/queueing/gate/PeriodicGate.h"
#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#endif

namespace combinedshapers {

#ifdef __linux__
class INET_API PeriodicGateCQF : public inet::queueing::PeriodicGate {
#endif
#ifdef _WIN32
class DLL_EXPORT PeriodicGateCQF : public inet::queueing::PeriodicGate {
#endif
protected:
  volatile bool isOddCycle;
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

