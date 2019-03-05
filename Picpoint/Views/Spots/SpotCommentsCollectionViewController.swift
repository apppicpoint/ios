//
//  SpotCommentsCollectionViewController.swift
//
//
//  Created by alumnos on 5/3/19.
//
import UIKit

private let reuseIdentifier = "Cell"

class SpotCommentsCollectionViewController: UICollectionViewController {
    
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDIdLoad")
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "commentCell")
        
        comments.append(Comment(id: 5, text: "Que chuloooo", user_id: 2,comment_id: 2, spot_id: 6, userImage: #imageLiteral(resourceName: "mari"), userName: "Mari"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
    }
    
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(comments.count)
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! SpotCommentsCollectionViewCell
        cell.comment.text = comments[indexPath.row].text
        cell.userName.text = comments[indexPath.row].userName
        cell.imageUser.image = comments[indexPath.row].userImage
        
        return cell
    }
    
    //Get comments
    func commentsList(){
        
    }
    
}
