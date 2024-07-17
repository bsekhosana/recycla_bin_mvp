import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:recycla_bin/core/widgets/custom_icon_button.dart';

import '../../../../core/constants/strings.dart';
import '../../../../core/utilities/utils.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  // In order to get hot reload to work, we need to pause the camera if the platform is Android
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.green,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: width * 0.8,
            ),
          ),
          Positioned(
            bottom: height*0.05,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: width*0.18,
                height: height*0.08,
                child: GestureDetector(
                  onTap: () async {
                    var scanData = await controller?.scannedDataStream.first;
                    if (scanData != null) {
                      Navigator.pop(context, scanData.code);
                    }
                  },
                  child: Container(
                    // padding: EdgeInsets.all(16.0), // Adjust padding as needed
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Utils.hexToColor(AppStrings.kRBPrimaryColor), Utils.hexToColor(AppStrings.kRBSecondaryColor)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Icon(
                        Icons.qr_code_scanner,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width*0.1,
                    ),
                  ),
              ))

              // ElevatedButton(
              //   onPressed: () async {
              //     var scanData = await controller?.scannedDataStream.first;
              //     if (scanData != null) {
              //       Navigator.pop(context, scanData.code);
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     shape: CircleBorder(), backgroundColor: Colors.green,
              //     padding: EdgeInsets.all(20), // Button color
              //   ),
              //   child: Icon(
              //     Icons.camera,
              //     size: 30,
              //     color: Colors.white,
              //   ),
              // ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      Navigator.pop(context, scanData.code); // Return the scanned data to the previous screen
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}