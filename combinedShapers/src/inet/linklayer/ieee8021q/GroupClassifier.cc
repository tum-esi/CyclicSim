
#include "./GroupClassifier.h"

#include <stdexcept>

namespace combinedshapers {
Define_Module(GroupClassifier);

void GroupClassifier::initialize(int stage) {
  PacketClassifierBase::initialize(stage);
  if (stage == INITSTAGE_LOCAL) {
    defaultGroupIndex = par("defaultGroupIndex");
    groupNumber = par("groupNumber");
    numBEQueues = par("numBEQueues");
    numCSQFGroups = par("numCSQFGroups");
    numCQFGroups = par("numCQFGroups");
  }
}

int GroupClassifier::classifyPacket(Packet *packet) {

  int groupId = defaultGroupIndex;
  std::string packetName(packet->getName());
  std::string tokenGroup = packetName.substr(packetName.find("gId") + 3);
  tokenGroup = tokenGroup.substr(0, tokenGroup.find("-"));
  bool err = false;
  try {
    groupId = std::stoi(tokenGroup);
  } catch (std::invalid_argument e) {
    err = true;
  }
  if (err) {
    tokenGroup = tokenGroup.substr(0, tokenGroup.find(":"));
    try {
      groupId = std::stoi(tokenGroup);
      err = false;
    } catch (std::invalid_argument e) {
      err = true;
    }
  }

  int qIdStartIdx = packetName.find("qId") + 3;
  std::string tokenQueue = packetName.substr(qIdStartIdx);
  if (qIdStartIdx != 3) {
    std::string qIds = tokenQueue.substr(0, tokenQueue.find("-"));
    std::string tail = tokenQueue.substr(tokenQueue.find("-"));
    if (groupId > 0 and groupId <= numCSQFGroups and *(packetName.end() - 1) != ' ') {
      int offset = numBEQueues + 2 * numCQFGroups + 3 * (numCSQFGroups - groupId);
      for (auto &i: qIds) {
        i += 5 - offset;
      }
      std::string newString = packetName.substr(0, qIdStartIdx) + qIds + tail + " ";
      packet->setName(newString.c_str());
    }
  }
  if (groupId > 0 and groupId <= groupNumber) {
    return getOutputGateIndex(groupId-1);
  }

  return getOutputGateIndex(defaultGroupIndex);
}

} // namespace combinedshapers
