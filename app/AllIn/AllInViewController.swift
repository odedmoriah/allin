/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreBluetooth

class AllInViewController: UIViewController {

//   @IBAction func Mybtn(_ sender: UIButton) {
//      var  valueInInt = -1
//      cc1350Peripheral.readValue(for: chre)
//      while( valueInInt == -1){
//         let data = chre.value
//         var byte:UInt8 = 0
//         data?.copyBytes(to: &byte, count: 1)
//
//         valueInInt = Int(byte)
//         print(valueInInt)
//        cc1350Peripheral.readValue(for: chre)
//    }
//      var parameter = NSInteger(1)
//      let data = NSData(bytes: &parameter, length: 1)
//      cc1350Peripheral.writeValue(data as Data, for: chre2, type: .withResponse)
//  }
//  @IBOutlet weak var currentHeartRateLabel: UILabel!
//  @IBOutlet weak var bodySensorLocationLabel: UILabel!
//  var centralManager: CBCentralManager!
//  let cc1350CBUUID = CBUUID(string: "0xFFF0")
//  let cc1350OrderCharacteristicCBUUID = CBUUID(string: "FFF1")
//  let cc1350Order2CharacteristicCBUUID = CBUUID(string: "FFF2")
//  let cc1350Order3CharacteristicCBUUID = CBUUID(string: "FFF3")
//  let notifyCharacteristicCBUUID = CBUUID(string: "FFF4")
//  var cc1350Peripheral: CBPeripheral!
//  var parameter = NSInteger(1)
//  var chre: CBCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "FFF2"), properties: CBCharacteristicProperties.read, value: nil, permissions: CBAttributePermissions.readable)
//  var chre2: CBCharacteristic = CBMutableCharacteristic(type: CBUUID(string: "FFF2"), properties: CBCharacteristicProperties.read, value: nil, permissions: CBAttributePermissions.readable)
  override func viewDidLoad() {
    super.viewDidLoad()
//    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//    backgroundImage.image = UIImage(named: "allinApp copy.jpeg")
//    backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
//    self.view.insertSubview(backgroundImage, at: 0)
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
    backgroundImage.image = UIImage(named: "allinApp copy.jpeg")
    backgroundImage.contentMode = .scaleAspectFill
    view.insertSubview(backgroundImage, at: 0)
    NSLayoutConstraint.activate([
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0),
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0),
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor,constant:0),
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:0)
    ])
//    centralManager = CBCentralManager(delegate: self, queue: nil)
    
    // Make the digits monospaces to avoid shifting when the numbers change
    //currentHeartRateLabel.font = UIFont.monospacedDigitSystemFont(ofSize: currentHeartRateLabel.font!.pointSize, weight: .regular)
  }
//  override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//
//    if (toInterfaceOrientation.isLandscape) {
//          let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//          backgroundImage.image = UIImage(named: "allinApp copy 2.jpeg")
//
//      }
//      else {
//          let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//          backgroundImage.image = UIImage(named: "allinApp copy.jpeg")
//      }
//    self.view.reloadInputViews()
//  }
}
//  @IBOutlet weak var myBleMess: UITextField!
//
//  @IBAction func myBleBtn(_ sender: UIButton) {
//  }
//  func onHeartRateReceived(_ heartRate: Int) {
//   // currentHeartRateLabel.text = String(heartRate)
//    print("BPM: \(heartRate)")
//  }
//}
//extension AllInViewController: CBPeripheralDelegate {
//
//  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
//                  error: Error?) {
//   let data = characteristic.value
//    var byte:UInt8 = 0
//    data?.copyBytes(to: &byte, count: 1)
//
//    let valueInInt = Int(byte)
//    print(valueInInt)
//  }
//
//  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//    guard let services = peripheral.services else { return }
//
//    for service in services {
//      print(service)
//      print(service.characteristics ?? "characteristics are nil")
//      peripheral.discoverCharacteristics(nil, for: service)
//    }
//
//  }
//  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
//                  error: Error?) {
//      cc1350Peripheral = peripheral
//    chre = service.characteristics![0]
//    chre2 = service.characteristics![1]
//    print(chre2)
//  }
//}
//extension AllInViewController: CBCentralManagerDelegate {
//  func centralManagerDidUpdateState(_ central: CBCentralManager) {
//    switch central.state {
//      case .unknown:
//        print("central.state is .unknown")
//      case .resetting:
//        print("central.state is .resetting")
//      case .unsupported:
//        print("central.state is .unsupported")
//      case .unauthorized:
//        print("central.state is .unauthorized")
//      case .poweredOff:
//        print("central.state is .poweredOff")
//      case .poweredOn:
//        print("central.state is .poweredOn")
//
//    }
//    centralManager.scanForPeripherals(withServices: [cc1350CBUUID])
//  }
//  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
//                      advertisementData: [String: Any], rssi RSSI: NSNumber){
//    print(peripheral)
//    cc1350Peripheral = peripheral
//    cc1350Peripheral.delegate = self
////    centralManager.stopScan()
//    centralManager.connect(cc1350Peripheral)
//    print(peripheral)
////    cc1350Peripheral.discoverServices(nil)
//  }
//
//  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//    cc1350Peripheral.discoverServices([cc1350CBUUID])
//  }
//
//
//}
