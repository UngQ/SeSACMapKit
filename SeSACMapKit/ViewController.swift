//
//  ViewController.swift
//  SeSACMapKit
//
//  Created by ungq on 1/15/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    let list = TheaterList().mapAnnotations
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.setTitle("전체보기", forSegmentAt: 0)
        segmentedControl.setTitle("메가박스", forSegmentAt: 1)
        segmentedControl.insertSegment(withTitle: "CGV", at: 2, animated: true)
        segmentedControl.insertSegment(withTitle: "롯데시네마", at: 3, animated:  true)
        
        for i in 0...list.count - 1 {
            
            let coordinate = CLLocationCoordinate2D(latitude: list[i].latitude, longitude: list[i].longitude)
            
            let annontation = MKPointAnnotation()
            annontation.coordinate = coordinate
            annontation.title = list[i].location
            
            mapView.addAnnotation(annontation)
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.554921, longitude: 126.970345), latitudinalMeters: 30000, longitudinalMeters: 30000)
            mapView.setRegion(region, animated: true)
            
        }
    }
    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            for i in 0...list.count - 1 {
                let coordinate = CLLocationCoordinate2D(latitude: list[i].latitude, longitude: list[i].longitude)
                
                let annontation = MKPointAnnotation()
                annontation.coordinate = coordinate
                annontation.title = list[i].location
                
                mapView.addAnnotation(annontation)
            }
        case 1:
            for i in 0...list.count - 1 {
                if list[i].type == "메가박스" {
                    let coordinate = CLLocationCoordinate2D(latitude: list[i].latitude, longitude: list[i].longitude)
                    let annontation = MKPointAnnotation()
                    annontation.coordinate = coordinate
                    annontation.title = list[i].location
                    
                    mapView.addAnnotation(annontation)
                }
            }
        case 2:
            for i in 0...list.count - 1 {
                if list[i].type == "CGV" {
                    let coordinate = CLLocationCoordinate2D(latitude: list[i].latitude, longitude: list[i].longitude)
                    let annontation = MKPointAnnotation()
                    annontation.coordinate = coordinate
                    annontation.title = list[i].location
                    
                    mapView.addAnnotation(annontation)
                }
            }
            
        case 3:
            for i in 0...list.count - 1 {
                if list[i].type == "롯데시네마" {
                    let coordinate = CLLocationCoordinate2D(latitude: list[i].latitude, longitude: list[i].longitude)
                    let annontation = MKPointAnnotation()
                    annontation.coordinate = coordinate
                    annontation.title = list[i].location
                    
                    mapView.addAnnotation(annontation)
                }
            }
        default:
            return
        }
    }
}
