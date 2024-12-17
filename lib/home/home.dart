import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodeServer extends StatefulWidget {
  @override
  _QRCodeServerState createState() => _QRCodeServerState();
}

class _QRCodeServerState extends State<QRCodeServer> {
  String receivedMessage = "في انتظار ....";
  late HttpServer _server;
  String _userId = '3';
  String _dateTime = '';
  late Future<String> _locationFuture;
  String qrData = '';
  bool isQRCodeVisible = true;

  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getUserLocation();
    _startWebSocketServer(); 
    _startTimeUpdate();
  }

  Future<String> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return "Lat: ${position.latitude}, Lng: ${position.longitude}";
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  void _startTimeUpdate() {
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _dateTime = _getCurrentDateTime();
      });
    });
  }

  Future<String> _getLocalIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }

 Future<void> _startWebSocketServer() async {
  try {
    String localIp = await _getLocalIpAddress();
    _server = await HttpServer.bind(localIp, 8080);
    print("HTTP Server running on http://$localIp:8080");

    _server.listen((HttpRequest request) {
      if (request.method == 'GET' && request.uri.path == '/scan') {
        setState(() {
          receivedMessage = "تم الاسكان بنجاح!";
          isQRCodeVisible = false; 
        });

        // إرسال استجابة بنجاح مع جافا سكريبت لإغلاق النافذة
        request.response.headers.contentType = ContentType.html;
        request.response.write("""
          <html>
            <head>
              <script type="text/javascript">
                setTimeout(function() {
                  window.close();
                }, 100); // إغلاق المتصفح بعد ثانية واحدة
                
              </script>
            </head>
            <body>
              <h1>تم الاسكان بنجاح!</h1>
            </body>
          </html>
        """);
        request.response.close();
      }
    });
  } catch (e) {
    print("Error starting HTTP Server: $e");
  }
}

  Widget _buildQRCode(String data) {
    return PrettyQr(
      data: data,
      size: 200,
      typeNumber: 10,
      roundEdges: true,
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _server.close(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder<String>(
            future: _locationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error fetching location"));
              } else if (snapshot.hasData) {
                String location = snapshot.data!;
                String qrDataToDisplay =
                    "http://${_server.address.host}:8080/scan?userId=$_userId&location=$location&datetime=$_dateTime";

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "اسكان QRCode باستخدام الابلكيشن ",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    if (isQRCodeVisible)
                      _buildQRCode(qrDataToDisplay),
                    if (!isQRCodeVisible)
                      Text(
                        'تم اسكان بنجاح  ابدا شغلك الان',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 40),
                    Text(
                      receivedMessage,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                );
              } else {
                return Center(child: Text("Location is unavailable"));
              }
            },
          ),
        ),
      ),
    );
  }
}
