using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ElephantNetworking {
    public enum NetworkMessageTypes {
        None,           // Error Packet

        //Protocol messages
        ProtocolVersion,    // What language are we speaking?
        ProtocolUserAndMac, // Who are we and what machine are we on?
        ProtocolPing,       // Ensure the communication is still open
        ProtocolPingReply,  // The expected reply to a ping
        ProtocolClose,      // Close the connection

        //Miscellaneous Commands
        Chat,           // A chat message [UserIDFrom | UserIDTo | Message]
        ScreenGrab,     // A screengrab [Workstation_ID | CaptureID | PartID]
        Execute,        // A command to execute
        PerformanceData,// Performance data

        // Logging data
        Login,          // A user has logged on (lets us track login time)
        LoginUpdate,    // Login update
        Alert,          // User did something strange, just sends a message to the server to alert
        LostConnection, // NetworkConnection was lost while the user was connected

        // Data requests
        DataReqLogins,  // Request all Login Data between times [StartTime | EndTime]
        DataReqUser,    // Request all login data for a specific user [Username | StartTime | EndTime]
        DataReqBanList, // Request all banned users data

        // Data replies
        DataRetLogins,  // Returned data for logins [TotalRecordsThisSent {forall [username | workstation | start | end]}]
        DataRetUser,    // Returned data for user logins [TotalRecordsThisSent | {forall [username | workstation | start | end]}]
        DataRetBanList, // Returned data for logins [TotalRecordsThisSent | {forall [username | workstation | start | end]}]

        // Assignment things
        AssignmentCreate,       // A staff member created an assignment
        AssignmentUpload,       // A student uploaded an assignment
        AssignmentCopyAddress,  // The server is letting the student client know where to copy to
        AssignmentGetLog,       // A staff member wants a log of students that submitted that assignment

        // Cache things
        GroupCacheGather,       // Get a list of groups
        UserCacheGather,        // Get a list of users
    }
}
