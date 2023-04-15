//
//  HomeCourselTableViewCell.swift
//  BookHive
//
//  Created by Anıl AVCI on 15.04.2023.
//

import UIKit

class HomeCourselTableViewCell: UITableViewCell {
    private var viewModel = HomeViewModel()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initViewModel()
        observeEvent()
        collectionSetup()
      
       
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        scaleCenterCell()
    }
    func initViewModel() {
        viewModel.fetchBestSeller()
    }
    func observeEvent() {
        print("DENEME")
        viewModel.eventHandler = { [weak self] event in
            guard let self else {return}
            
            switch event {
            case .loading:
                //indicator show
                print("Product loading...")
            case .stopLoading:
                // indicator hide
                print("Stop loading...")
            case .dataLoaded:
                if self.viewModel.bestSeller.count == 0 {
                    print("DATA COUNT ----->>>> 0")
                } else {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                print("Data loaded count...\( self.viewModel.bestSeller.count)")
            case .error(let error):
                print("HATA VAR!!!! \(error?.localizedDescription ?? "ERROR")")
            }
        }
    }
    // HomePage collection ilk açıldığında istenilen görünümü alması için;
    func scaleCenterCell() {
        let centerX = collectionView.contentOffset.x + collectionView.frame.size.width / 2
        for cell in collectionView.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 { offsetX = -offsetX }
            let scale = 1 - offsetX / collectionView.frame.size.width
            cell.transform = CGAffineTransform(scaleX: scale, y: scale) } }

    private func collectionSetup() {
        collectionView.register(HomeCollectionViewCoursel.nib(), forCellWithReuseIdentifier: HomeCollectionViewCoursel.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
}
extension HomeCourselTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bestSeller.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCoursel.identifier, for: indexPath) as! HomeCollectionViewCoursel
        // Download image and set
        let olid = viewModel.bestSeller[indexPath.item].availability?.openlibrary_edition
        let cover = String(viewModel.bestSeller[indexPath.row].cover_id ?? 0)
        if cover == nil {
            cell.imageView.setImageOlid(with: olid!)
        } else {
            cell.imageView.setImageCover(with: Int(cover)!)

        }
        
        
        return cell
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width / 2
        for cell in collectionView.visibleCells {
            var offsetX = centerX - cell.center.x
            if offsetX < 0 {
                offsetX = -offsetX
            }
            let scale = 1 - offsetX / scrollView.frame.size.width
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
