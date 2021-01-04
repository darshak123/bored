
import UIKit
import Alamofire

enum PlaceType {
  case All
  case Geocode
  case Address
  case Establishment
  case Regions
  case Cities

  var description : String {
    switch self {
    case .All: return ""
    case .Geocode: return "geocode"
    case .Address: return "address"
    case .Establishment: return "establishment"
    case .Regions: return "regions"
    case .Cities: return "cities"
    }
  }
}

struct Place {
  let id: String
  let description: String
    let city: String
    let state: String
    let lat: String
    let lng: String
}

protocol GooglePlacesAutocompleteDelegate {
  func placeSelected(place: Place)
  func placeViewClosed()
}

// MARK: - GooglePlacesAutocomplete
class GooglePlacesAutocomplete: UINavigationController {
  var gpaViewController: GooglePlacesAutocompleteContainer?

  var placeDelegate: GooglePlacesAutocompleteDelegate? {
    get { return gpaViewController?.delegate }
    set { gpaViewController?.delegate = newValue }
  }

  convenience init(apiKey: String, placeType: PlaceType = .All) {
    let gpaViewController = GooglePlacesAutocompleteContainer(
      apiKey: apiKey,
      placeType: placeType
    )

    self.init(rootViewController: gpaViewController)
    self.gpaViewController = gpaViewController

    let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target: self, action: #selector(Stream.close))

    gpaViewController.navigationItem.leftBarButtonItem = closeButton
    gpaViewController.navigationItem.title = "Enter Address"
  }

  func close() {
    placeDelegate?.placeViewClosed()
  }
}

// MARK: - GooglePlaceSearchDisplayController
class GooglePlaceSearchDisplayController: UISearchDisplayController {
    override func setActive(_ visible: Bool, animated: Bool) {
        if isActive == visible { return }

        searchContentsController.navigationController?.isNavigationBarHidden = true
    super.setActive(visible, animated: animated)

        searchContentsController.navigationController?.isNavigationBarHidden = false

    if visible {
      searchBar.becomeFirstResponder()
    } else {
      searchBar.resignFirstResponder()
    }
  }
}

// MARK: - GooglePlacesAutocompleteContainer
class GooglePlacesAutocompleteContainer: UIViewController {
  var delegate: GooglePlacesAutocompleteDelegate?
  var apiKey: String?
  var places = [Place]()
  var placeType: PlaceType = .All

  convenience init(apiKey: String, placeType: PlaceType = .All) {
    self.init(nibName: "GooglePlacesAutocomplete", bundle: nil)
    self.apiKey = apiKey
    self.placeType = placeType
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let tv: UITableView? = searchDisplayController?.searchResultsTableView
    tv?.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
}

// MARK: - GooglePlacesAutocompleteContainer (UITableViewDataSource / UITableViewDelegate)
extension GooglePlacesAutocompleteContainer: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (self.searchDisplayController?.searchResultsTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath))! as UITableViewCell

        // Get the corresponding candy from our candies array
        let place = self.places[indexPath.row]

        // Configure the cell
        cell.textLabel!.text = place.description
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator

        return cell
      }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places.count
  }


    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.placeSelected(place: self.places[indexPath.row])
  }
}

// MARK: - GooglePlacesAutocompleteContainer (UISearchDisplayDelegate)
extension GooglePlacesAutocompleteContainer: UISearchDisplayDelegate {
  func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
    getPlaces(searchString: searchString)
    return false
  }

  private func getPlaces(searchString: String) {
    
    
    
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")!
            self.showProgress()
            
            let param = [
                "input": searchString,
                "type": "(\(placeType.description))",
                "key": apiKey ?? ""
              ]
            
            Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let response = value as! NSDictionary
                            if let predictions = response["predictions"] as? Array<AnyObject> {
                              self.places = predictions.map { (prediction: AnyObject) -> Place in
                                
                                return Place(id: prediction["id"] as! String, description: prediction["description"] as! String, city: prediction["description"] as! String, state: prediction["description"] as! String, lat: prediction["description"] as! String, lng: prediction["description"] as! String)
                                
                              }
                            }
                          }
                        
                    }
                case .failure:
                    self.dissmissProgress()
                    self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                        
                        },{action2 in
                            self.getPlaces(searchString: searchString)
                        }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
                    self.getPlaces(searchString: searchString)
                }, nil])
        }
    
    self.searchDisplayController?.searchResultsTableView.reloadData()
    }
  }

