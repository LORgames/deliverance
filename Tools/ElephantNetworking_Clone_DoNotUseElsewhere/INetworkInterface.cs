using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ElephantNetworking {
    public interface INetworkInterface {
        void AddListener(INetworkListen obj);
        void RemoveListener(INetworkListen obj);

        bool SendMessage(NetworkMessage message);
        void Shutdown();
    }
}
