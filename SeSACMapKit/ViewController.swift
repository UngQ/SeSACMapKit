//
//  ViewController.swift
//  SeSACMapKit
//
//  Created by ungq on 1/15/24.
//

import UIKit
import MapKit
import CoreLocation //1. 위치기능 임포트

enum TheaterName: String {
	case total = "모두보기"
	case megabox = "메가박스"
	case cgv = "CGV"
	case lottecinema = "롯데시네마"
}

class ViewController: UIViewController {
    let list = TheaterList().mapAnnotations
    
	@IBOutlet var currentLocationButton: UIButton!
	@IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
	
	let locationManager = CLLocationManager() //2. 위치매니저 생성
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let rightButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(test))
		
		navigationItem.rightBarButtonItem = rightButton
		
		currentLocationButton.configuration = .currentLocationStyle()
		
		
		//4. 부하 소환 (프로토콜 연결)
		locationManager.delegate = self
		
		
		showTotalTheater()
		
		checkDeviceLocationAuthorization()
		
		
	}
	
	
	@objc func test() {
		showLocationFilterActionSheet()
	}
	
	
	@IBAction func currentLocationButtonClicked(_ sender: UIButton) {
		
		checkDeviceLocationAuthorization()
	}
}

extension ViewController {
	func checkDeviceLocationAuthorization() {
		
		DispatchQueue.global().async {
			
			if CLLocationManager.locationServicesEnabled() {
				let authorization: CLAuthorizationStatus
				
				if #available(iOS 14.0, *) {
					authorization = self.locationManager.authorizationStatus
				} else {
					authorization = CLLocationManager.authorizationStatus()
				}
				
				DispatchQueue.main.async {
					
					self.checkCurrentLocationAuthorization(status: authorization)
				}
			}
			else {
					print("??")
				}
			}
		}
		
		
	func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
		
		switch status {
		case .notDetermined:
			
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestWhenInUseAuthorization()
			
		case .denied:
			
			showLocationSettingAlert()
			locationManager.startUpdatingLocation()
			
		case .authorizedWhenInUse:
			
			locationManager.startUpdatingLocation()
			
		default:
			print("checkCurrentLocationAuthorization default")
		}
	}
	
	func showLocationSettingAlert() {
		let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 이용할 수 없습니다. 설정을 변경해주세요.", preferredStyle: .alert)
		
		let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
			if let setting = URL(string: UIApplication.openSettingsURLString) {
				UIApplication.shared.open(setting)
			} else {
				print("showLocationSettingAlert 오류")
			}
		}
		
		let cancel = UIAlertAction(title: "취소", style: .cancel)
		
		alert.addAction(goSetting)
		alert.addAction(cancel)
		
		present(alert, animated: true)
	}
	
	func showLocationFilterActionSheet() {
		
		
		let actionSheet = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
		
		let megabox = UIAlertAction(title: TheaterName.megabox.rawValue, style: .default) { _ in
			self.showFilterTheater(theater: TheaterName.megabox.rawValue)
			
		}
		let cgv = UIAlertAction(title: TheaterName.cgv.rawValue, style: .default) { _ in
			
			self.showFilterTheater(theater: TheaterName.cgv.rawValue)
		}
		
		
		let lotteCinema = UIAlertAction(title: TheaterName.lottecinema.rawValue, style: .default) { _ in
			
			self.showFilterTheater(theater: TheaterName.lottecinema.rawValue)
		}
		
		let total = UIAlertAction(title: "모두보기", style: .default) { UIAlertAction in
			self.showTotalTheater()
		}
		
		let cancel = UIAlertAction(title: "취소", style: .cancel)
		

		actionSheet.addAction(megabox)
		actionSheet.addAction(cgv)
		actionSheet.addAction(lotteCinema)
		actionSheet.addAction(total)
		actionSheet.addAction(cancel)
		
		present(actionSheet, animated: true)
	}
	
	func showTotalTheater() {
		self.mapView.removeAnnotations(self.mapView.annotations)
		
		for i in 0...self.list.count - 1 {
			let coordinate = CLLocationCoordinate2D(latitude: self.list[i].latitude, longitude: self.list[i].longitude)
			let annontation = MKPointAnnotation()
			annontation.coordinate = coordinate
			annontation.title = self.list[i].location
			
			self.mapView.addAnnotation(annontation)
		}
	}
	
	func showFilterTheater(theater: String) {
		self.mapView.removeAnnotations(self.mapView.annotations)
		
		for i in 0...self.list.count - 1 {
			if self.list[i].type == theater {
				let coordinate = CLLocationCoordinate2D(latitude: self.list[i].latitude, longitude: self.list[i].longitude)
				let annontation = MKPointAnnotation()
				annontation.coordinate = coordinate
				annontation.title = self.list[i].location
				
				self.mapView.addAnnotation(annontation)
			}
		}
	}
	
	func setRegionAndAnnontation(center: CLLocationCoordinate2D) {
		
		let region = MKCoordinateRegion(center: center, latitudinalMeters: 30000, longitudinalMeters: 30000)
		mapView.setRegion(region, animated: true)
		
	}
}


//3. 위치 프로토콜 채택
extension ViewController: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last?.coordinate {
			setRegionAndAnnontation(center: location)
		}
		
		locationManager.stopUpdatingLocation()
			
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		//37.654165, 127.049696 씨드큐브 창동
		
		print("거부했어")
		
		setRegionAndAnnontation(center: CLLocationCoordinate2D(latitude: 37.654165, longitude: 127.049696))
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkDeviceLocationAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		checkDeviceLocationAuthorization()
	}
	
	
	
}
