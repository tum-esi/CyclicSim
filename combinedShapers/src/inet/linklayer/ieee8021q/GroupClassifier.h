#ifndef __combinedshapers_GroupClassifier_H
#define __combinedshapers_GroupClassifier_H

#include "inet/queueing/base/PacketClassifierBase.h"
#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#endif

namespace combinedshapers {

using namespace inet;

#ifdef __linux__
class INET_API GroupClassifier : public queueing::PacketClassifierBase
#endif
#ifdef _WIN32
class DLL_EXPORT GroupClassifier : public queueing::PacketClassifierBase
#endif
{
protected:
  int defaultGroupIndex = 0;
  int groupNumber;
  int numBEQueues;
  int numCSQFGroups;
  int numCQFGroups;

protected:
  virtual void initialize(int stage) override;
  virtual int classifyPacket(Packet *packet) override;
};

} // namespace combinedshapers

#endif

