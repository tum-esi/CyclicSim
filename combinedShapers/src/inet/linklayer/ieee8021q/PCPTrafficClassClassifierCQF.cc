
#include "./PcpTrafficClassClassifierCQF.h"

#include "inet/linklayer/common/PcpTag_m.h"
#include <memory>
#include <omnetpp/cexception.h>
#include <omnetpp/cvaluearray.h>

namespace combinedshapers {
Define_Module(PCPTrafficClassClassifierCQF);

void PCPTrafficClassClassifierCQF::initialize(int stage) {
  PacketClassifierBase::initialize(stage);
  if (stage == INITSTAGE_LOCAL) {
    mode = par("mode");
    mapping = check_and_cast<cValueArray *>(par("mapping").objectValue());
    defaultGateIndex = par("defaultGateIndex");
    try {
      int moduleIdx = getIndex();
      auto isOddCycleArray = check_and_cast<cValueArray *>(
                       getParentModule()->par("isOddCycle").objectValue());
      int numCQFGroups = getParentModule()->par("numCQFGroups").intValue();
      if (numCQFGroups > isOddCycleArray->size()) {
        isOddCycleArray->setCapacity(numCQFGroups);
        for (int i = 0; i < numCQFGroups; i++) {
          isOddCycleArray->set(i, cValue(false));
        }
        getParentModule()->par("isOddCycle").setObjectValue(isOddCycleArray->dup());
      }
      isOddCycle = isOddCycleArray->get(moduleIdx);
    } catch (cRuntimeError e) {
      isOddCycle = getParentModule()->par("isOddCycle").boolValue();
    }
    numBEQueues = par("numBEQueues").intValue();
  }
}

int PCPTrafficClassClassifierCQF::classifyPacket(Packet *packet) {
  handleParameterChange("isOddCycle");
  int pcp = -1;
  switch (*mode) {
  case 'r': {
    auto pcpReq = packet->findTag<PcpReq>();
    if (pcpReq != nullptr)
      pcp = pcpReq->getPcp();
    break;
  }
  case 'i': {
    auto pcpInd = packet->findTag<PcpInd>();
    if (pcpInd != nullptr)
      pcp = pcpInd->getPcp();
    break;
  }
  case 'b': {
    auto pcpReq = packet->findTag<PcpReq>();
    if (pcpReq != nullptr)
      pcp = pcpReq->getPcp();
    else {
      auto pcpInd = packet->findTag<PcpInd>();
      if (pcpInd != nullptr)
        pcp = pcpInd->getPcp();
    }
    break;
  }
  }
  if (pcp > -1 and pcp != 4) {
    int numTrafficClasses = numBEQueues;
    auto pcpToGateIndex =
        check_and_cast<cValueArray *>(mapping->get(pcp).objectValue());
    return getOutputGateIndex(
        pcpToGateIndex->get(numTrafficClasses - 1).intValue() + 2);
  } else if (pcp == 4) {
    return getOutputGateIndex(!isOddCycle);
  }
  return getOutputGateIndex(defaultGateIndex);
}

void combinedshapers::PCPTrafficClassClassifierCQF::handleParameterChange(
    const char *name) {
  // NOTE: parameters are set from the gate schedule configurator modules
  // does this mean: when no "offset" value is set from the configurator module
  // => choose parameter value
  if (!strcmp(name, "isOddCycle")) {
    try {
      int moduleIdx = getIndex();
      isOddCycle = check_and_cast<cValueArray *>(
                       getParentModule()->par("isOddCycle").objectValue())
                       ->get(moduleIdx);
    } catch (cRuntimeError e) {
      isOddCycle = getParentModule()->par("isOddCycle").boolValue();
    }
  }
}

} // namespace combinedshapers

