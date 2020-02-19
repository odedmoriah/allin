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

import SwiftUI
import CoreData
import UIKit

class StatusTableViewCell: UITableViewCell {
  
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var itemNameText: UITextField!
    @IBOutlet weak var itemNumberText: UITextField!
    @IBAction func onChange(_ sender: UISwitch) {
     
    }
    
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}

class ItemListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
  
  var managedObjectContext: NSManagedObjectContext!

  @IBOutlet weak var myTableView: UITableView!
  
 
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(loadItems().count)
    return loadItems().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatusTableViewCell") as? StatusTableViewCell else {
      return StatusTableViewCell()
    }
    let itemInBag: ItemInBag = loadItems()[indexPath.row]
    
    cell.itemNameText.text = itemInBag.name
    cell.itemNumberText.text = itemInBag.number
    cell.mySwitch.setOn(itemInBag.included, animated: true)
    cell.mySwitch.tag = indexPath.row
   
    return cell
  }
  
  
  
  
  

  override func viewDidLoad() {
    super.viewDidLoad()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
//    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
//    backgroundImage.translatesAutoresizingMaskIntoConstraints = false
//    backgroundImage.image = UIImage(named: "allinApp copy.jpeg")
//    backgroundImage.contentMode = .scaleAspectFill
    
//    myTableView.sendSubview(toBack: backgroundImage)
//    NSLayoutConstraint.activate([
//        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:0),
//        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:0),
//        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor,constant:0),
//        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:0)
//    ])
  }

  
  
  @IBAction func AddNew(_ sender: Any) {
    updateItems()
    let item: ItemInBag = NSEntityDescription.insertNewObject(forEntityName: "ItemInBag", into: managedObjectContext) as! ItemInBag
    item.name = "item " + String(loadItems().count)
    item.number = String(loadItems().count)
    item.included = false
    do {
      try managedObjectContext.save()
    } catch let error as NSError {
      NSLog("My Error: %@", error)
    }
    
    myTableView.reloadData()
  }

  @IBAction func saveItems(_ sender: UIBarButtonItem) {
    updateItems()
  }
  
  
  
  func loadItems() -> [ItemInBag] {
    let fetchRequest: NSFetchRequest<ItemInBag> = ItemInBag.fetchRequest()
    var result: [ItemInBag] = []
    do {
      result = try managedObjectContext.fetch(fetchRequest)
    } catch {
      NSLog("My Error: %@", error as NSError)
    }
    return result
  }
  
  
  func updateItems() {
    if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{

    let context = container.viewContext

    let fetchRequest = NSFetchRequest<ItemInBag>(entityName: "ItemInBag")


    do {

        let results = try context.fetch(fetchRequest)
      
        var row = 0
      
        if (results.count > 0){

          for result in results{
            let cell = myTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! StatusTableViewCell
            result.name = cell.itemNameText.text
            result.number = cell.itemNumberText.text
            result.included = cell.mySwitch.isOn
            try context.save()
            row = row + 1
          }
      }
      }catch let error {

          print("Error....: \(error)")

      }
    }
  }
      
}
