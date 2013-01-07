using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Drawing;
using System.Net.Sockets;

namespace CityTools.Physics {
    public class BinaryReader {

        private List<Byte> out_data;
        private Byte[] in_data;
        private int seemlessReadIndex = 0;

        internal BinaryReader(Byte[] received) {
            in_data = received;
            seemlessReadIndex = 0;
        }

        public BinaryReader(string filename) {
            File.OpenRead(filename);
            out_data = new List<byte>();
        }

        internal void Encode(out Byte[] outBytes, out int length) {
            if (out_data != null) {
                length = out_data.Count;

                out_data.InsertRange(0, BitConverter.GetBytes(IPAddress.HostToNetworkOrder(length)));
                length += 4;
                outBytes = out_data.ToArray();
            } else {
                throw new Exception("MISSING OUTDATA!");
            }
        }

        public void AddInt(int number) {
            out_data.AddRange(BitConverter.GetBytes(IPAddress.HostToNetworkOrder(number)));
        }

        public int GetInt(int index) {
            seemlessReadIndex += 4;
            return IPAddress.NetworkToHostOrder(BitConverter.ToInt32(in_data, index));
        }

        public int GetInt() {
            return GetInt(seemlessReadIndex);
        }

        public void AddLong(long number) {
            out_data.AddRange(BitConverter.GetBytes(IPAddress.HostToNetworkOrder(number)));
        }

        public long GetLong(int index) {
            seemlessReadIndex += 8;
            return IPAddress.NetworkToHostOrder(BitConverter.ToInt64(in_data, index));
        }

        public long GetLong() {
            return GetLong(seemlessReadIndex);
        }

        public void AddFloat(float number) {
            out_data.AddRange(BitConverter.GetBytes(number));
        }

        public float GetFloat(int index) {
            seemlessReadIndex += 4;
            return BitConverter.ToSingle(in_data, index);
        }

        public float GetFloat() {
            return GetFloat(seemlessReadIndex);
        }

        public void AddString(string Message) {
            Byte[] encoded = Encoding.UTF8.GetBytes(Message);
            out_data.AddRange(BitConverter.GetBytes(IPAddress.HostToNetworkOrder((short)encoded.Length)));
            out_data.AddRange(encoded);
        }

        public string GetString(int index) {
            //Get length as NUMBER OF BYTES
            short length = IPAddress.NetworkToHostOrder(BitConverter.ToInt16(in_data, index));
            seemlessReadIndex += 2 + length;

            return Encoding.UTF8.GetString(in_data, index + 2, length);
        }

        public string GetString() {
            return GetString(seemlessReadIndex);
        }

        public override string ToString() {
            if(in_data != null) {
                return "[NMI: " + in_data.Length + "B]";
            } else {
                return "[NMO: " + out_data.Count + "B]";
            }
        }

        internal void Flip() {
            if (out_data != null) {
                out_data.RemoveRange(0, 6);
                in_data = out_data.ToArray();
                out_data.Clear();
                out_data = null;
                seemlessReadIndex = 0;
            } else if(in_data != null) {
                out_data = new List<byte>();
                out_data.AddRange(in_data);
                in_data = null;
            }
        }

        public void Dispose() {
            if(out_data != null) {
                out_data.Clear();
                out_data = null;
            }

            if (in_data != null) {
                in_data = null;
            }
        }
    }
}
