//
//  MyTableViewCell.swift
//  Armario
//
//  Created by Fernando Villalba  on 4/4/22.
//

import UIKit
import CoreData

class GarmentsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    weak var cellDelegate: CollectionViewCellDelegate?
    var coreDataStack: CoreDataStack!
    var usuario: UserViewModel!
    
    var managedContext: NSManagedObjectContext! {
        get
        {
            return coreDataStack.context
        }
    }
    
    var sectionHeader : String?
    
    var sectionGarments : [Garment] {
        get
        {
            return getGarmentsByType(type: sectionHeader ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.collectionViewLayout = layout()
    }
    
    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionGarments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "garmentsCollectionCell", for: indexPath) as! GarmentsCollectionViewCell
        
        let targetSize = CGSize(width: 200, height: 200)
        let scaledImage = self.sectionGarments[indexPath.row].image?.scalePreservingAspectRatio(
            targetSize: targetSize
        )
        
        cell.garmentImage = scaledImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: -80, left: 10, bottom: -10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/2.5, height: self.collectionView.frame.width/2)
    }
    
    // MARK: - UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.cellDelegate?.collectionView(collectionviewcell: cell as? GarmentsCollectionViewCell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    // MARK: - layout() : Genera un layout de una sola fila con todas las celdas del mismo tamaño
    // REF : https://localcoder.org/uicollectionview-one-row-or-column
    func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(200),
            heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitem: item, count: 1) // *
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .flexible(10), top: .flexible(0),
            trailing: nil, bottom: .flexible(collectionView.frame.height/4.5))
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 50
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        let layout = UICollectionViewCompositionalLayout(
            section: section, configuration:config)
        return layout
    }
    
    // MARK: - getGarmentsByType(type: String) : Obtiene todas las prendas de un tipo dado
    func getGarmentsByType(type: String) -> [Garment]
    {

        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Garment")
        
        let userPredicate = NSPredicate(format: "user == %@", self.usuario.user)
        let typePredicate = NSPredicate(format: "type == %@", type)
        
        let predicates = NSCompoundPredicate(type: .and, subpredicates: [userPredicate, typePredicate])
        fetchRequest.predicate = predicates
        
        var results: [Garment] = []
        
        do
        {
            results = try coreDataStack.context.fetch(fetchRequest) as! [Garment]
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return results
    }
    
}

protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: GarmentsCollectionViewCell?, index: Int, didTappedInTableViewCell: GarmentsTableViewCell)
    // other delegate methods that you can define to perform action in viewcontroller
}
