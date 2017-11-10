//
//  MapViewController.swift
//  FoodTrade
//
//  Created by Grant Brooks on 9/26/17.
//  Copyright © 2017 dly. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    weak var delegate: MapViewDelegate?
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var myMapView: MKMapView!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("ERROR")
            } else {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                
                // Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                print(latitude,longitude)
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.myMapView.setRegion(region, animated: true)
                
                
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Confirm Address", message: response!.mapItems[0].name, preferredStyle: .actionSheet)
                
                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    print("Cancel")
                }
                actionSheetControllerIOS8.addAction(cancelActionButton)
                
                let saveActionButton = UIAlertAction(title: "Confirm", style: .default)
                { _ in
                    print("Confirm")
                    //pass location
                    print(latitude!,longitude!)
                    self.delegate?.addCoordinates (by: self, latitude: latitude!, longitude: longitude!, locationName: response!.mapItems[0].name!)
                    
                    
                }
                actionSheetControllerIOS8.addAction(saveActionButton)
                
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
