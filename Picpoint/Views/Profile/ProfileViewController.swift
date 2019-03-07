
import UIKit

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
            let child = PicPortfolioCreatedViewController()
            child.viewWillAppear(true)
            PicPorfolioContainer.isHidden = false
            PicPersonsalContainer.isHidden = true
            SpotsCreatedContainer.isHidden = true
            

            break
            
        case 1:
            let child = PicPersonalCreatedViewController()
            child.viewWillAppear(true)
            PicPorfolioContainer.isHidden = true
            PicPersonsalContainer.isHidden = false
            SpotsCreatedContainer.isHidden = true

            break
            
        case 2:
            let child = SpotsCreatedViewController()
            child.viewWillAppear(true)
            PicPorfolioContainer.isHidden = true
            PicPersonsalContainer.isHidden = true
            SpotsCreatedContainer.isHidden = false
        
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
    
   

}
