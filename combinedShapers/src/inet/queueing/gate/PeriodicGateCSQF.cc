//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//



#include "./PeriodicGateCSQF.h"
#include <inet/queueing/gate/PeriodicGate.h>
#include <omnetpp/cexception.h>
#include <omnetpp/checkandcast.h>
#include <omnetpp/cvalue.h>
#include <omnetpp/cvaluearray.h>

#define DEFAULT_CYCLE_TYPE 0

Define_Module(combinedshapers::PeriodicGateCSQF);

void combinedshapers::PeriodicGateCSQF::initialize(int stage) {
  inet::queueing::PeriodicGate::initialize(stage);
  cycleType = DEFAULT_CYCLE_TYPE;
  alwaysOpen = par("alwaysOpen").boolValue();
  queueIdx = getIndex()/3;
}

void combinedshapers::PeriodicGateCSQF::handleParameterChange(const char *name) {
  // NOTE: parameters are set from the gate schedule configurator modules
  // does this mean: when no "offset" value is set from the configurator module
  // => choose parameter value
  if (!strcmp(name, "offset"))
    initialOffset = par("offset");
  else if (!strcmp(name, "initiallyOpen"))
    initiallyOpen = par("initiallyOpen");
  else if (!strcmp(name, "durations"))
    readDurationsPar();

  initializeGating();
}

void combinedshapers::PeriodicGateCSQF::processChangeTimer() {
  if (!isOpen_) {
    try {
      auto cycleTypeArray = omnetpp::check_and_cast<omnetpp::cValueArray *>(
          getParentModule()->par("cycleType").objectValue());
      cycleType = cycleTypeArray->get(queueIdx).intValue();
      cycleType = (cycleType + 1) % 3;
      cycleTypeArray->set(queueIdx, cycleType);
      getParentModule()->par("cycleType").setObjectValue(omnetpp::check_and_cast<cObject *>(cycleTypeArray->dup()));
    } catch (omnetpp::cRuntimeError e) {
      cycleType = getParentModule()->par("cycleType").intValue();
      cycleType = (cycleType + 1) % 3;
      getParentModule()->par("cycleType").setIntValue(cycleType);
    }
  }
  if (isOpen_ and !alwaysOpen)
    close();
  else if (!isOpen_)
    open();
}


