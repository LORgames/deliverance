
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ElephantNetworking {
    public class Settings {

        public const string SERVER_HOSTNAME = "10.37.20.5";
        //public const string SERVER_HOSTNAME = "192.168.0.11";

        public const int SERVER_VIEWER_PORT = 27855; //Port for viewer controls
        public const int SERVER_LOG_PORT = 27856; //Port for posting logs and gathering log data
        public const int SERVER_ASSIGNMENT_PORT = 27857; //Port for submitting and control of the assignment system
        public const int SERVER_CACHE_PORT = 27860; //Port for cache updates

        public const int CLIENT_HARD_PORT = 27858; //The service port: 'hard' because only the server should be able to talk to it
        public const int CLIENT_SOFT_PORT = 27859; //The interactive port: 'soft' because anyone can communicate with it
    }
}
