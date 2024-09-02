package combinedshapers.inet.linklayer.ieee8021q;

import inet.queueing.base.PacketClassifierBase;
import inet.queueing.contract.IPacketClassifier;

//
// This module classified packets based on the groupId value [0, 3].
//
module GroupClassifier extends PacketClassifierBase like IPacketClassifier
{
    parameters:
        int defaultGroupIndex = default(0); // default gate index if no PCP found
        int groupNumber = default(3); // Number of groups (excluding AVB)
        int numBEQueues = default(1);
        int numCSQFGroups = default(1);
        int numCQFGroups = default(2);
        @class(GroupClassifier);
}

