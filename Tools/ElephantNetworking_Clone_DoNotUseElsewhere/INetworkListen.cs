using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ElephantNetworking {
    public interface INetworkListen {
        bool OnData(NetworkMessage data);
    }
}
