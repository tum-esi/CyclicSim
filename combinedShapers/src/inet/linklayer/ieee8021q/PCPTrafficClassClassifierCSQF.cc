
#include "./PCPTrafficClassClassifierCSQF.h"

#include "inet/linklayer/common/PcpTag_m.h"
#include "inet/queueing/queue/PacketQueue.h"
#include <cctype>
#include <cstdio>
#include <omnetpp/checkandcast.h>
#include <string>

namespace combinedshapers {
Define_Module(PCPTrafficClassClassifierCSQF);

void PCPTrafficClassClassifierCSQF::initialize(int stage) {
  PacketClassifierBase::initialize(stage);
  if (stage == INITSTAGE_LOCAL) {
    mode = par("mode");
    mapping = check_and_cast<cValueArray *>(par("mapping").objectValue());
    defaultGateIndex = par("defaultGateIndex");
    try {
      int moduleIdx = getIndex();
      auto cycleTypeArray = check_and_cast<cValueArray *>(
          getParentModule()->par("cycleType").objectValue());
      int numCSQFGroups = getParentModule()->par("numCSQFGroups").intValue();
      if (numCSQFGroups > cycleTypeArray->size()) {
        cycleTypeArray->setCapacity(numCSQFGroups);
        cycleTypeArray =
            new cValueArray(cycleTypeArray->getName(), numCSQFGroups);
        for (int i = 0; i < numCSQFGroups; i++) {
          cycleTypeArray->set(i, cValue(0));
        }
        getParentModule()
            ->par("cycleType")
            .setObjectValue(cycleTypeArray->dup());
      }
      cycleType = cycleTypeArray->get(moduleIdx);
    } catch (cRuntimeError e) {
      cycleType = getParentModule()->par("cycleType").intValue();
    }
    numBEQueues = par("numBEQueues").intValue();
  }
}

int PCPTrafficClassClassifierCSQF::classifyPacket(Packet *packet) {
  int pcp = -1;
  handleParameterChange("cycleType");
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

  std::string packetName(packet->getName());
  int qIdStartIdx = packetName.find("qId") + 3;
  std::string tokenQueue = packetName.substr(qIdStartIdx);
  if (qIdStartIdx != 3) {
    int queueId = tokenQueue[0] - '0';
    int queueingGateIdx = 7 - queueId;
    // int queueingGateIdx = queueId - 5;
    auto nextQueue = check_and_cast<inet::queueing::PacketQueue *>(
        getParentModule()->getSubmodule("queue", queueingGateIdx));
    auto maxLength = nextQueue->getMaxTotalLength();
    auto maxSize = nextQueue->getMaxNumPackets();
    if (maxLength == b(-1) and maxSize == -1) {
      int tokenGroupEnd = tokenQueue.end() - tokenQueue.begin();
      std::string newName = packetName.substr(0, qIdStartIdx) +
                            tokenQueue.substr(1, tokenGroupEnd);
      packet->setName(newName.c_str());
      return getOutputGateIndex(queueingGateIdx);
    }
  }

  if (pcp > -1 and pcp != 4) {
    int numTrafficClasses = numBEQueues;
    auto pcpToGateIndex =
        check_and_cast<cValueArray *>(mapping->get(pcp).objectValue());
    return getOutputGateIndex(
        pcpToGateIndex->get(numTrafficClasses - 1).intValue() + 3);
  } else if (pcp != -1) {
    auto queueingGateIdx = (cycleType + 1) % 3;
    auto toleratingGateIdx = (cycleType + 2) % 3;
    auto nextQueue = check_and_cast<inet::queueing::PacketQueue *>(
        getParentModule()->getSubmodule("queue", queueingGateIdx));

    auto packetLength = packet->getDataLength();
    auto maxLength = nextQueue->getMaxTotalLength();
    auto predictedLength = nextQueue->getTotalLength() + packetLength;

    auto maxSize = nextQueue->getMaxNumPackets();
    auto predictedSize = nextQueue->getNumPackets() + 1;

    bool overLength = (maxLength != b(-1)) and (predictedLength > maxLength);
    bool overSized = (maxSize != -1) and (predictedSize > maxSize);

    if (overLength or overSized) {
      return getOutputGateIndex(toleratingGateIdx);
    } else {
      return getOutputGateIndex(queueingGateIdx);
    }
  }
  return getOutputGateIndex(defaultGateIndex);
}

void combinedshapers::PCPTrafficClassClassifierCSQF::handleParameterChange(
    const char *name) {
  // NOTE: parameters are set from the gate schedule configurator modules
  // does this mean: when no "offset" value is set from the configurator module
  // => choose parameter value
  if (!strcmp(name, "cycleType")) {
    try {
      int moduleIdx = getIndex();
      cycleType = check_and_cast<cValueArray *>(
                      getParentModule()->par("cycleType").objectValue())
                      ->get(moduleIdx);
    } catch (cRuntimeError e) {
      cycleType = getParentModule()->par("cycleType").intValue();
    }
  }
}

} // namespace combinedshapers

