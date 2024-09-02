//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//


#include "./PeriodicGateCQF.h"
#include <cmath>
#include <cstdio>
#include <inet/queueing/gate/PeriodicGate.h>
#include <omnetpp/cobject.h>
#include <omnetpp/cvaluearray.h>
#include <omnetpp/checkandcast.h>

#define DEFAULT_IS_ODD_CYCLE false

Define_Module(combinedshapers::PeriodicGateCQF);

void combinedshapers::PeriodicGateCQF::initialize(int stage) {
  inet::queueing::PeriodicGate::initialize(stage);
  isOddCycle = DEFAULT_IS_ODD_CYCLE;
  alwaysOpen = par("alwaysOpen").boolValue();
  queueIdx = getIndex()/2;
}

void combinedshapers::PeriodicGateCQF::handleParameterChange(const char *name) {
  // NOTE: parameters are set from the gate schedule configurator modules
  // does this mean: when no "offset" value is set from the configurator module
  // => choose parameter value
  if (!strcmp(name, "offset"))
    initialOffset = par("offset");
  else if (!strcmp(name, "initiallyOpen"))
    initiallyOpen = par("initiallyOpen");
  else if (!strcmp(name, "durations"))
    readDurationsPar();
  else if (!strcmp(name, "isOddCycle")) {
    try {
      int moduleIdx = getIndex();
      isOddCycle = omnetpp::check_and_cast<omnetpp::cValueArray *>(getParentModule()->par("isOddCycle").objectValue())->get(moduleIdx);
    } catch (omnetpp::cRuntimeError e) {
      isOddCycle = getParentModule()->par("isOddCycle").boolValue();
    }
  }

  initializeGating();
}

void combinedshapers::PeriodicGateCQF::processChangeTimer() {
  isOddCycle = !isOddCycle;
  try {
    auto isOddCycles = omnetpp::check_and_cast<omnetpp::cValueArray *>(getParentModule()->par("isOddCycle").objectValue());
    isOddCycles->set(queueIdx, isOddCycle);
    getParentModule()->par("isOddCycle").setObjectValue(omnetpp::check_and_cast<omnetpp::cObject *>(isOddCycles->dup()));
  } catch (omnetpp::cRuntimeError e) {
    getParentModule()->par("isOddCycle").setBoolValue(isOddCycle);
  }
  if (isOpen_ && !alwaysOpen)
    close();
  else
    open();
}
