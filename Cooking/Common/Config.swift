import Foundation
import CloudKit
import UIKit

var containerIdentifier = "iCloud.vanzylarno.MyLifeCompanion"
var container = CKContainer(identifier: containerIdentifier)
var database = container.privateCloudDatabase
var GroceryListZoneID = CKRecordZone.ID(zoneName: "GroceryList")


