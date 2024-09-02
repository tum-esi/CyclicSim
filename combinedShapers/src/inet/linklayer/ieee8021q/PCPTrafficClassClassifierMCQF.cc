//
// Copyright (C) 2020 OpenSim Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later
//



#include "./PcpTrafficClassClassifierMCQF.h"

#include "inet/queueing/queue/PacketQueue.h"
#include <cctype>
#include <inet/linklayer/common/PcpTag_m.h>
#include <omnetpp/checkandcast.h>
#include <omnetpp/cvaluearray.h>
#include <stdexcept>
#define DEFAULT_GROUP_ID 0
#define DEFAULT_QUEUE_ID -1
#define DEFAULT_PCP -1

namespace combinedshapers {
Define_Module(PCPTrafficClassClassifierMCQF);

void PCPTrafficClassClassifierMCQF::initialize(int stage) {
  PacketClassifierBase::initialize(stage);
  if (stage == INITSTAGE_LOCAL) {
    mode = par("mode");
    mapping = check_and_cast<cValueArray *>(par("mapping").objectValue());
    defaultGateIndex = par("defaultGateIndex");
    numCQFGroups =  par("numCQFGroups").intValue();
    numCSQFGroups =  par("numCSQFGroups").intValue();
    numBEQueues =  par("numBEQueues").intValue();
    cycleType = check_and_cast<cValueArray *>(
        getParentModule()->par("cycleType").objectValue());
    if (cycleType->size() < numCSQFGroups) {
      cycleType->setCapacity(par("numCSQFGroups").intValue());
      for (int i = 0;i < cycleType->size();i++) {
        cycleType->set(i, 0);
      }
    }
    isOddCycle = check_and_cast<cValueArray *>(
        getParentModule()->par("isOddCycle").objectValue());
    if (isOddCycle->size() < numCQFGroups) {
      isOddCycle->setCapacity(par("numCQFGroups").intValue());
      for (int i = 0;i < isOddCycle->size();i++) {
        isOddCycle->set(i, false);
      }
    }
  }
}

int PCPTrafficClassClassifierMCQF::classifyPacket(Packet *packet) {

  handleParameterChange("cycleType");
  handleParameterChange("isOddCycle");

  int pcp = -1;
  int groupId = DEFAULT_GROUP_ID;
  int queueId = DEFAULT_QUEUE_ID;

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
    if (pcpReq != nullptr) {
      pcp = pcpReq->getPcp();
    } else {
      auto pcpInd = packet->findTag<PcpInd>();
      if (pcpInd != nullptr)
        pcp = pcpInd->getPcp();
    }
    break;
  }
  }

  std::string packetName(packet->getFullName());
  std::string token_group = packetName.substr(packetName.find("gId") + 3);
  token_group = token_group.substr(0, token_group.find("-"));
  bool err = false;
  try {
    groupId = std::stoi(token_group);
  } catch (std::invalid_argument e) {
    err = true;
  }
  if (err) {
    token_group = token_group.substr(0, token_group.find(":"));
    try {
      groupId = std::stoi(token_group);
      err = false;
    } catch (std::invalid_argument e) {
      groupId = DEFAULT_GROUP_ID;
      err = true;
    }
  }

  std::string tokenQueue = packetName.substr(packetName.find("qId") + 3);
  int qIdStartIdx = packetName.find("qId") + 3;
  tokenQueue = tokenQueue.substr(0, tokenQueue.find("-"));
  if (std::isdigit(tokenQueue[0])) {
    queueId = tokenQueue[0] - '0';
    int numQueue = numBEQueues + 3 * numCSQFGroups + 2 * numCQFGroups;
    queueId = numQueue - queueId - 1;
  } else {
    queueId = DEFAULT_QUEUE_ID;
  }

  if (queueId != DEFAULT_QUEUE_ID) {
    auto currentQueue = check_and_cast<inet::queueing::PacketQueue *>(
        getParentModule()->getSubmodule("queue", queueId));
    auto maxLength = currentQueue->getMaxTotalLength();
    auto maxSize = currentQueue->getMaxNumPackets();
    if (maxLength == b(-1) and maxSize == -1) {
      int tokenQueueEnd = tokenQueue.end() - tokenQueue.begin();
      std::string newName = packetName.substr(0, qIdStartIdx) +
                            tokenQueue.substr(1, tokenQueueEnd);
      packet->setName(newName.c_str());
      return getOutputGateIndex(queueId);
    }
  }

  if (groupId == DEFAULT_GROUP_ID) { // best-effort traffic
    int numTrafficClasses = gateSize("out");
    auto pcpToGateIndex = check_and_cast<cValueArray *>(mapping->get(pcp).objectValue());
    return getOutputGateIndex(pcpToGateIndex->get(numTrafficClasses - 1));
  } else if (groupId > 0 and groupId <= numCSQFGroups) { // video traffic, csqf
    int offset = (groupId-1) * 3;
    auto packetLength = packet->getDataLength();

    auto queueingGateIdx = (cycleType->get(groupId-1).intValue() + 1) % 3 + offset;
    auto toleratingGateIdx = (cycleType->get(groupId-1).intValue() + 2) % 3 + offset;

    auto currentQueue = check_and_cast<inet::queueing::PacketQueue *>(
        getParentModule()->getSubmodule("queue", queueingGateIdx));

    auto maxLength = currentQueue->getMaxTotalLength();
    auto predictedLength = currentQueue->getTotalLength() + packetLength;

    auto maxSize = currentQueue->getMaxNumPackets();
    auto predictedSize = currentQueue->getNumPackets() + 1;

    bool overLength = (maxLength != b(-1)) and (predictedLength > maxLength);
    bool overSized = (maxSize != -1) and (predictedSize > maxSize);

    if (overLength or overSized) {
      return getOutputGateIndex(toleratingGateIdx);
    } else {
      return getOutputGateIndex(queueingGateIdx);
    }
  } else if (groupId > numCSQFGroups and groupId <= numCSQFGroups + numCQFGroups) { // video traffic, cqf
    int offset = numCSQFGroups * 3 + (groupId - numCSQFGroups - 1) * 2;
    int queueingGateIdx = (isOddCycle->get(groupId - numCSQFGroups - 1).boolValue() + 1) % 2 + offset;
    return getOutputGateIndex(queueingGateIdx);
  }
  return getOutputGateIndex(defaultGateIndex);
}

void PCPTrafficClassClassifierMCQF::handleParameterChange(const char *name) {
  if (!strcmp(name, "isOddCycle")) {
    isOddCycle = check_and_cast<cValueArray *>(
        getParentModule()->par("isOddCycle").objectValue());
  }
  if (!strcmp(name, "cycleType")) {
    cycleType = check_and_cast<cValueArray *>(
        getParentModule()->par("cycleType").objectValue());
  }
}

} // namespace combinedshapers





