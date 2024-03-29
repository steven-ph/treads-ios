
import UIKit
import RealmSwift

class Run: Object {
  
  @objc dynamic public private(set) var id: String = ""
  @objc dynamic public private(set) var date: NSDate = NSDate()
  @objc dynamic public private(set) var pace: Int = 0
  @objc dynamic public private(set) var distance: Double = 0.0
  @objc dynamic public private(set) var duration: Int = 0
  public private(set) var locations: List<Location> = List<Location>()
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  override class func indexedProperties() -> [String] {
    return ["date", "pace", "duration"]
  }
  
  convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
    self.init()
    self.id = UUID().uuidString.lowercased()
    self.date = NSDate()
    self.pace = pace
    self.distance = distance
    self.duration = duration
    self.locations = locations
  }
  
  static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>) {
    REALM_QUEUE.sync {
      let run = Run(pace: pace, distance: distance, duration: duration, locations: locations)
      do {
        let realm = try Realm(configuration: RealmConfig.runDataConfig)
        try realm.write {
          realm.add(run)
          try realm.commitWrite()
        }
      } catch {
        debugPrint("Error adding Run to Realm: \(error)")
      }
    }
  }
  
  static func getAllRuns() -> Results<Run>? {
    do {
      let realm = try Realm(configuration: RealmConfig.runDataConfig)
      var runs = realm.objects(Run.self)
      runs = runs.sorted(byKeyPath: "date", ascending: false)
      return runs
    } catch {
      debugPrint("Error adding Run to Realm: \(error)")
      return nil
    }
    
  }
  
  static func getRun(byId id: String) -> Run? {
    do {
      let realm = try Realm(configuration: RealmConfig.runDataConfig)
      
      return realm.object(ofType: Run.self, forPrimaryKey: id)
    } catch {
      debugPrint("Error adding Run to Realm: \(error)")
      return nil
    }
  }
  
}
