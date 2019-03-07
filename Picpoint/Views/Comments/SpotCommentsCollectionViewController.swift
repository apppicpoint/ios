//
//  SpotCommentsCollectionViewController.swift
//
//
//  Created by alumnos on 5/3/19.
//
import UIKit
import Alamofire

private let reuseIdentifier = "Cell"

class SpotCommentsCollectionViewController: UICollectionViewController {
    
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDIdLoad")
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "commentCell")
        
        comments.append(Comment(id: 5, text: "Que chuloooo", user_id: 2,comment_id: 2, spot_id: 6, userImage: #imageLiteral(resourceName: "mari"), userName: "Mari"))
        print("comments.count", comments.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("comments count",comments.count)
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
        //let url = Constants.url
        //Todavia no hay endpoint
    }
    
}
