//
//  ViewController.swift
//  HalaalApp
//
//  Created by ZainAnjum on 12/06/2018.
//  Copyright © 2018 ZainAnjum. All rights reserved.
//

import UIKit
import MapKit

class DetailController: UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
   
    let base_url = "http://halaalappinvestment.com/admin/services/"
    var HalalData : Halal?
    var NearestCafe : nearestMaps?
    let margin = "10"
    var typeCellString = "TypeCell"
    lazy var mapView =  MKMapView()
    
    let FaIcons : [FAType] = [.FAHome, .FABed, .FABath, .FAUsd, .FABuilding, .FAArchive, .FAClockO]
    
    
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    let Bsize = CGSize(width: 40, height: 40)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: typeCellString, for: indexPath) as! TypeCell
        
        cell.IconimageView.image = UIImage(icon: FaIcons[indexPath.row], size: Bsize)
        if HalalData != nil{
            cell.titleLabel.backgroundColor = .white
        }
        switch indexPath.row {
        case 0:
            if let text = HalalData?.building_type{
            cell.titleLabel.text = text
            }
        case 1:
            if let text = HalalData?.floors_number{
                cell.titleLabel.text = text
            }
        case 2:
            if let text = HalalData?.bathrooms{
                cell.titleLabel.text = text
            }
        case 3:
            if let text = HalalData?.price{
                cell.titleLabel.text = text
            }
        case 4:
            if let text = HalalData?.property_status{
                cell.titleLabel.text = text
            }
        case 5:
            if let text = HalalData?.parking_type{
                cell.titleLabel.text = text
            }
        case 6:
            if let text = HalalData?.building_age{
                cell.titleLabel.text = text
            }
        default:
            cell.titleLabel.text = "              "
            cell.titleLabel.backgroundColor = .darkGray
        }
        return cell
    }


    var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: 12, height: 1800)
        sv.backgroundColor = .white
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let OfferInfoView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(8)
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let TypeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let AvailableShareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(8)
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    let NearestCafeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(8)
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    let AddMapTitleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(8)
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    let CafeDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "logo.png")
        imageView.backgroundColor = UIColor.darkGray
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
   lazy var containerView = UIView()
    fileprivate func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1200)
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        self.view.addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
        
        
        scrollView.addSubview(containerView)
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
    }
    
    
    func setupHeaderView(title: String, image: FAType, view: UIView, size: CGFloat) {
        let Imagesize = CGSize(width: size, height: size)
        let imageView = UIImageView()
        imageView.image = UIImage(icon: image, size: Imagesize, orientation: .up, textColor: .yellow, backgroundColor: .white)
        imageView.layer.cornerRadius = size / 2.0
        
        let titleLabel = UILabel()
        titleLabel.text = title
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        
        view.addConstraintsWithFormat(format: "V:|[v0(40)]|", views: imageView)
        view.addConstraintsWithFormat(format: "H:|[v0(40)]-10-[v1]", views: imageView, titleLabel)
        
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: titleLabel)
    }
    func setupMapView(long : CLLocationDegrees, lat: CLLocationDegrees) {
        
        let location = CLLocationCoordinate2DMake(lat, long)
        let span = MKCoordinateSpanMake(0.002, 0.002)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        
        mapView.addAnnotation(annotation)
    }
    
    
    func setupViews() {
        let horizontalCOnstrian = "H:|-(\(self.margin))-[v0]-(\(self.margin))-|"
        containerView.addSubview(userProfileImageView)
        containerView.addSubview(OfferInfoView)
        containerView.addSubview(TypeView)
        containerView.addSubview(AvailableShareView)
        containerView.addSubview(AddMapTitleView)
        containerView.addSubview(mapView)
        containerView.addSubview(NearestCafeView)
        containerView.addSubview(CafeDetailView)
        
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: userProfileImageView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: OfferInfoView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: TypeView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: AvailableShareView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: AddMapTitleView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: mapView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: NearestCafeView)
        containerView.addConstraintsWithFormat(format: horizontalCOnstrian, views: CafeDetailView)
        
        containerView.addConstraintsWithFormat(format: "V:|[v0(150)]-2-[v1(40)]-10-[v2(120)]-20-[v3(40)]-20-[v4(40)]-10-[v5(300)]-10-[v6(40)]-10-[v7(300)]", views: userProfileImageView,OfferInfoView, TypeView, AvailableShareView, AddMapTitleView, mapView, NearestCafeView, CafeDetailView)
        
        
    }
    var CollectionView: UICollectionView?
    
    func createCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        
        // Now setup the flowLayout required for drawing the cells
        let space = 5.0 as CGFloat
        //        let heights = (view.frame.width - 16 - 16) * 9 / 16
        
        // Set view cell size
        flowLayout.itemSize = CGSize(width: 80, height: 60)
        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space
        flowLayout.scrollDirection = .vertical
        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space
        
        // Finally create the CollectionView
        
        CollectionView = UICollectionView(frame: CGRect(x:0,y: 0,width: view.frame.width,height: 150), collectionViewLayout: flowLayout)
        
        
        CollectionView?.register(TypeCell.self, forCellWithReuseIdentifier: typeCellString)
        
        CollectionView?.backgroundColor = UIColor.white
        TypeView.addSubview(CollectionView!)
    }
   var tableView = UITableView()
    func createTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        CafeDetailView.addSubview(tableView)
        CafeDetailView.addConstraintsWithFormat(format: "H:|-(\(self.margin))-[v0]-(\(self.margin))-|", views: tableView)
        CafeDetailView.addConstraintsWithFormat(format: "V:|[v0(300)]|", views: tableView)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.NearestCafe?.results?.count ?? 0
    }
    let tableViewCellString = "TableViewCell"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: tableViewCellString)
        guard let name = self.NearestCafe?.results?[indexPath.row].name else { return cell }
        cell.textLabel?.text = name
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRelityInfo()
        self.title = HalalData?.description
        view.backgroundColor = .white
        setupScrollView()
        setupViews()
        setupHeaderView(title: "Offer Info", image: .FAInfoCircle, view: OfferInfoView, size: 30)
        setupHeaderView(title: "AvailableShareView", image: .FAInfoCircle, view: AvailableShareView, size: 30)
        setupHeaderView(title: "Add Map Property Location", image: .FASearch, view: AddMapTitleView, size: 30)
        setupHeaderView(title: "Nearest Cafe and Restaurents", image: .FACutlery, view: NearestCafeView, size: 30)

        createCollectionView()
        CollectionView?.delegate = self
        CollectionView?.dataSource = self
        
        
//        setupMapView(long: long, lat: lat)
        createTableView()
    }



}
