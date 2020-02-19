/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

//import SwiftUI
import CoreBluetooth
import CoreData
import UIKit

class CheckStatusTableViewCell: UITableViewCell {
     
  @IBOutlet weak var itemNameText: UITextField!
  
  @IBOutlet weak var itemNumberText: UITextField!
  
  @IBOutlet weak var mySwitch: UISwitch!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}

class CheckAllInViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  var STARTPOOLING: UInt8 = 1
  var ENDPOOLING: UInt8 = 0
  var  NEWSTICKERFLAG = 0
  let UNREADY = 12
  @IBOutlet weak var myCheckBtn: UIBarButtonItem!
  var getStickerStatus = 0

  @IBOutlet weak var myScrooling: UIActivityIndicatorView!
  var centralManager: CBCentralManager!
  let cc1350CBUUID = CBUUID(string: "0xFFF0")
  let cc1350OrderCharacteristicCBUUID = CBUUID(string: "FFF1")
  let cc1350Order2CharacteristicCBUUID = CBUUID(string: "FFF2")
  let cc1350Order3CharacteristicCBUUID = CBUUID(string: "FFF3")
  let notifyCharacteristicCBUUID = CBUUID(string: "FFF4")
  var cc1350Peripheral: CBPeripheral?
  var parameter = NSInteger(1)
  var sticker: [UInt8]?
  var chre: CBCharacteristic?
  var chre2: CBCharacteristic?
  var chre3: CBCharacteristic?
  var chre4: CBCharacteristic?
  var chre5: CBCharacteristic?
  var stickerDic = [String: Int]()
  var IndexDic = [String: Int]()
  var lastSticker: UInt8 = 0
  var managedObjectContext: NSManagedObjectContext!
  var timer = true
  var firstTime = true
  var notIncludedCounter : Int = 0
  @IBOutlet weak var myTableView: UITableView!
  
  
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(loadItems().count)
    return loadItems().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CheckStatusTableViewCell") as? CheckStatusTableViewCell else {
      return CheckStatusTableViewCell()
    }
    let itemInBag: ItemInBag = loadItems()[indexPath.row]
  
    cell.itemNameText.text = itemInBag.name
    cell.itemNumberText.text = itemInBag.number
    cell.mySwitch.setOn(false, animated: true)
    cell.mySwitch.isEnabled = false
    cell.mySwitch.tag = indexPath.row
    stickerDic[itemInBag.number!] = indexPath.row
    IndexDic[itemInBag.number!] = 1
    return cell
  }
  
  
  func verifySticker(byteArray: [UInt8]) {
    let hexSticker : NSMutableString = ""
    for i in 1...byteArray.count{
      hexSticker.append(convertToString(char: byteArray[i-1]))
    }
    if let val = self.stickerDic[String(hexSticker)] {
        (myTableView.cellForRow(at: IndexPath(row: val, section: 0)) as! CheckStatusTableViewCell).mySwitch.isEnabled = true
        (myTableView.cellForRow(at: IndexPath(row: val, section: 0)) as! CheckStatusTableViewCell).mySwitch.setOn(true, animated: false)
        stickerDic.remove(at:stickerDic.index(forKey: String(hexSticker))!)
        }
      }
      
//  }
  
  func currentTimeInMiliseconds() -> Int64 {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    formatter.timeZone = TimeZone.current
//      print(formatter.timeZone)
    let current = formatter.string(from: Date())
//      print(current)
    let stringCurrent = formatter.date(from: current)
//      print(stringCurrent)
    let inMillis = (Int64)(floor(stringCurrent!.timeIntervalSince1970))
    return inMillis;
  }
  
  @IBAction func onCheck_clk(_ sender: Any) {
    if ((cc1350Peripheral == nil) || (chre3 == nil)){
      let alert = UIAlertController(title: "Alert", message: "No BLE connection", preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
      self.present(alert, animated: true, completion: nil)
      return
    }
    else{
      myScrooling.startAnimating()
      myCheckBtn.isEnabled = false
    var data = Data(bytes: &STARTPOOLING, count: 1)
      cc1350Peripheral!.writeValue(data, for: chre3!, type: .withResponse )
      NEWSTICKERFLAG = 0
      lastSticker = 0;
//      cc1350Peripheral!.readValue(for: chre2!)
      cc1350Peripheral!.setNotifyValue(true, for: chre4!)

      
      DispatchQueue.global(qos: .background).async {
        
        let startTime = self.currentTimeInMiliseconds()
        while(self.timer){
          let endTime = self.currentTimeInMiliseconds()
          let elapse = endTime - startTime
          if ((elapse > 37) || (self.stickerDic.capacity == 0)){
            self.timer = false
          }
        }
        data = Data(bytes: &self.ENDPOOLING, count: 1)
        self.cc1350Peripheral!.writeValue(data, for: self.chre3!, type: .withResponse )
        DispatchQueue.main.async {
          self.myCheckBtn.isEnabled = true
          self.myScrooling.stopAnimating()
        }
        
      }
    }
  }
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
    cc1350Peripheral = nil
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    backgroundImage.image = UIImage(named: "allinApp copy.jpeg")
    backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
    self.view.insertSubview(backgroundImage, at: 0)
    centralManager = CBCentralManager(delegate: self, queue: nil)
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
  }

  
  
  
  func loadItems() -> [ItemInBag] {
    let fetchRequest: NSFetchRequest<ItemInBag> = ItemInBag.fetchRequest()
    var result: [ItemInBag] = []
    do {
      result = try managedObjectContext.fetch(fetchRequest)
    } catch {
      NSLog("My Error: %@", error as NSError)
    }
    var includedItems: [ItemInBag] = []
//    var i : Int = 0
    if (result.count > 0){
      for i in 1...result.count {
          if (result[i-1].included){
            includedItems.append(result[i-1])
          }
      }
    }
    return includedItems
  }
  
  
  
//--------stickers functions
    func convertToString(char: UInt8) -> String {
      var newStringBytes:[UInt8]
      if (char > 15){
        newStringBytes = [0,0]
        newStringBytes[1] = UInt8(char % 16)
        newStringBytes[0] = UInt8((char - newStringBytes[0]) / 16)
      }
      else{
        newStringBytes = [0]
        newStringBytes[0] = char
      }
      for i in 0...newStringBytes.count-1{
          if !(newStringBytes[i] >= 0 && newStringBytes[i] <= 15) {
              print("Input is wrong")
              break
          }
          if newStringBytes[i] >= 9 {
            newStringBytes[i] = newStringBytes[i] + 65 - 10
          }
          else{
            newStringBytes[i] = newStringBytes[i] + 48
          }
      }
              
    let data = Data(bytes: newStringBytes)
    let string = String(data: data, encoding: .utf8)
    return string!
    }
  
  
  
  
  
}




//----------------ble extensions----------------
extension CheckAllInViewController: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
    if (characteristic == chre4){
      print(chre4!.value ?? "no value")
      guard let characteristicData = characteristic.value else {
        return }
        sticker = [UInt8](characteristicData)
        verifySticker(byteArray: sticker!)
    }
}
  
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }
    
    for service in services {
      peripheral.discoverCharacteristics(nil, for: service)
    }
    
  }
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                  error: Error?) {
    
    cc1350Peripheral = peripheral
    chre = service.characteristics![0]
    chre2 = service.characteristics![1]
    peripheral.setNotifyValue(true, for: chre2!)
    chre3 = service.characteristics![2]
    chre4 = service.characteristics![3]

    chre5 = service.characteristics![4]
  }
  
  
}


extension CheckAllInViewController: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
      case .unknown:
        print("central.state is .unknown")
      case .resetting:
        print("central.state is .resetting")
      case .unsupported:
        print("central.state is .unsupported")
      case .unauthorized:
        print("central.state is .unauthorized")
      case .poweredOff:
        print("central.state is .poweredOff")
      case .poweredOn:
        print("central.state is .poweredOn")
        
    }
    cc1350Peripheral = nil
    centralManager.scanForPeripherals(withServices: [cc1350CBUUID])
    
  }
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                      advertisementData: [String: Any], rssi RSSI: NSNumber){
    print(peripheral)
    cc1350Peripheral = peripheral
    cc1350Peripheral!.delegate = self
    centralManager.connect(cc1350Peripheral!)
    print(peripheral)
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    cc1350Peripheral!.discoverServices([cc1350CBUUID])
  }
  
  
}
