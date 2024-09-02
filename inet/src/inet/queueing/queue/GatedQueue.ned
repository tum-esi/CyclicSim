//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package inet.queueing.queue;

//
// This module implements a queue with a gate
//
import inet.queueing.contract.IPacketBuffer;
import inet.queueing.contract.IPacketQueue;
import inet.queueing.contract.IPacketGate;
import inet.queueing.queue.CompoundPacketQueueBase;
import inet.queueing.gate.GateControlList;

module GatedQueue extends CompoundPacketQueueBase
{
    parameters:
        int numTrafficClasses = default(8); // number of traffic categories
        double bitrate @unit(bps);
        bool hasGcl = default(false);
        *.bitrate = default(this.bitrate);
        *.extraLength = default(64b); // overhead for Ethernet PHY header
    submodules:
        buffer: <default("")> like IPacketBuffer if typename != "" {
            parameters:
                @display("p=100,225");
        }
        gateControlList: GateControlList if hasGcl {
            parameters:
                @display("p=300,225");
        }
		queue: <default("PacketQueue")> like IPacketQueue {
                @display("p=300,100,column,125");
        }
        transmissionGate: <default("PeriodicGate")> like IPacketGate {
            parameters:
                @display("p=700,100,column,125");
        } 
	connections:
	    in --> { @display("m=w"); } --> queue.in;
	    queue.out --> transmissionGate.in;
	    transmissionGate.out --> out;
}
