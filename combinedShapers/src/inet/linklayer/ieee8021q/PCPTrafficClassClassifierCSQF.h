
#ifndef __CQF_FP_PCPTRAFFICCLASSCLASSIFIERCSQF_H
#define __CQF_FP_PCPTRAFFICCLASSCLASSIFIERCSQF_H

#include "inet/queueing/base/PacketClassifierBase.h"
#ifdef _WIN32
#define DLL_EXPORT __declspec(dllexport)
#endif

namespace combinedshapers {

using namespace inet;

#ifdef __linux__
class INET_API PCPTrafficClassClassifierCSQF
    : public queueing::PacketClassifierBase
#endif
#ifdef _WIN32
class DLL_EXPORT PCPTrafficClassClassifierCSQF
    : public queueing::PacketClassifierBase
#endif
{
protected:
  const char *mode = nullptr;
  cValueArray *mapping = nullptr;
  int defaultGateIndex = -1;
  volatile int cycleType;
  int numBEQueues;

protected:
  virtual void initialize(int stage) override;
  virtual int classifyPacket(Packet *packet) override;
  virtual void handleParameterChange(const char *name) override;
};

} // namespace combinedshapers

#endif


