
import UIKit
import Alamofire

class SpotCommentsCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var commentInput: UITextView!
    var comments = [Comment]()

    @IBOutlet weak var commentsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsCollectionView.delegate = self
        commentsCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
        comments.removeAll()
        comments.append(Comment(id: 5, text: "Nice spot to make photos", user_id: 2,comment_id: 2, spot_id: 6, userImage: #imageLiteral(resourceName: "mari"), userName: "Mari"))
        print("comments.count view will appear", comments.count)
        commentsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("comments count collection view",comments.count)
        return comments.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! SpotCommentsCollectionViewCell
        cell.comment.text = comments[indexPath.row].text
        cell.userName.text = comments[indexPath.row].userName
        cell.imageUser.image = comments[indexPath.row].userImage
        print(cell.comment.text)
        return cell
    }
    
    //Get comments NO HAY COMENTARIOS CREADOS TODAVIA
    /*func commentsList(){
        let url = Constants.url+"comments"
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON {
            response in
            
            if(response.response?.statusCode == 200){
                self.comments = [Comment]()
                
                let jsonResponse = response.result.value as! [String:Any]
                print(jsonResponse)
                /*for comment in jsonResponse {
                    self.comments.append(Comment(id: comment["id"] as! Int, text: comment["text"] as! String, user_id: comment["user_id"] as! Int, comment_id: comment["comment_id"] as! Int, spot_id: comment["spot_id"] as! Int, userImage: "Hola", userName: "Manolo"))
                }*/
                
            }
           
        }
        
    }
    
    func getUserFromComment(id: Int){
        let url = Constants.url+"users/"+String(id)
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization": UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON {
            response in
            let user = response.result.value
            
            if(response.response?.statusCode == 200){
                
            }
        }
    }*/
    
    @IBAction func sendCommentBtn(_ sender: Any) {
        print("enviar comentario")
    }
}
