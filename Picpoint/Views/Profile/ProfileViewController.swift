
import UIKit
import AlamofireImage
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var numbersOfFollowers: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var descriptionProfile: UILabel!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var PicPersonsalContainer: UIView!
    @IBOutlet weak var SpotsCreatedContainer: UIView!
    @IBOutlet weak var PicPorfolioContainer: UIView!
    
    @IBAction func ChangeFeed(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
           
            PicPorfolioContainer.isHidden = false
            PicPersonsalContainer.isHidden = true
            SpotsCreatedContainer.isHidden = true
            
            for ViewController in childViewControllers{
                
                if(ViewController as? PicPortfolioCreatedViewController != nil){
                    
                    ViewController.viewWillAppear(true)
                }
            }
       
            break
            
        case 1:
            
            PicPorfolioContainer.isHidden = true
            PicPersonsalContainer.isHidden = false
            SpotsCreatedContainer.isHidden = true
            
            for ViewController in childViewControllers{
                
                if(ViewController as? PicPersonalCreatedViewController != nil){
                    
                    ViewController.viewWillAppear(true)
                }
            }

            break
            
        case 2:
           
            PicPorfolioContainer.isHidden = true
            PicPersonsalContainer.isHidden = true
            SpotsCreatedContainer.isHidden = false
            
            for ViewController in childViewControllers{
                
                if(ViewController as? SpotsCreatedViewController != nil ){
                    
                    ViewController.viewWillAppear(true)
                }
            }
        
            break
            
        default:
            break
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let child = MyChildViewController()
        addChildViewController(child)
        view.addSubview(child.view)
        // Setup auto layout constraints for child.view..
        child.didMove(toParentViewController: self)*/
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "token") //Borra el token guardado en el dispositivo.
        UserDefaults.standard.removeObject(forKey: "user_id")
        UserDefaults.standard.removeObject(forKey: "role_id")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) //Coge la referencia del storyboard
        
        //Declará el viewController al que se quiere acceder y abre sin necesidad de segue.
        //Es la mejor opción, ya que con segue se arrastraría el navigationController y el tabBarController.
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "singIn") as! LoginViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func getUserData(){
        
        let url = Constants.url+"users/" + UserDefaults.standard.string(forKey: "user_id")!
        let _headers : HTTPHeaders = [
            "Content-Type":"application/x-www-form-urlencoded",
            "Authorization":UserDefaults.standard.string(forKey: "token")!
        ]
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.httpBody, headers: _headers).responseJSON{
            response in
            
            switch response.result {
            case .success:
                let jsonResponse = response.result.value as! [String:Any]
                let data = jsonResponse["user"] as! [String: Any]
                
                self.nickName.text = data["nickName"] as? String
                self.descriptionProfile.text = data["biography"] as? String
                
                self.getUserImg(imageName: data["photo"] as! String)
                
                if let desc = data["biography"] as? String {
                    self.descriptionProfile.text = desc
                }
                else {
                    self.descriptionProfile.isHidden = true
                }
            
            case .failure(let error):
                print(error,"error user")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getUserImg(imageName : String){
        let url = Constants.url+"imgLow/"+imageName //Se le pasa el nombre de la foto, el cual lo tiene el spot.
        Alamofire.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success:
                self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                self.profileImage.clipsToBounds = true
                let data = response.result.value
                self.profileImage.image = data!
            case .failure(let error):
                print(error,"error img")
                let alert = UIAlertController(title: "Ups! Something was wrong.", message:
                    "Check your connection and try it later", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
   

}
