import UIKit
import Alamofire
import MapKit
class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailFieldL: UITextField!
    @IBOutlet weak var passwordFieldL: UITextField!
    let validator = Validator()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        emailFieldL.whiteDesign()
        passwordFieldL.whiteDesign()
        
        self.hideKeyboardWhenTappedAround()

    }
    
    //Botón de login
    @IBAction func login(_ sender: Any) {
        if !Connectivity.isLocationEnabled() {
            
                let alert = UIAlertController(title: "Pls! Activate the GPS", message:
                    "Picpoint cannot work without it", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style:
                    .cancel, handler: { (accion) in}))
                self.present(alert, animated: true, completion: nil)
            
        } else {
            if validateInputs() {
                requestLogin()
            }
        }
        
        
    }
    
    //Botón de usuario sin registro
    @IBAction func enterWithoutRegistration(_ sender: Any) {
        if !Connectivity.isLocationEnabled() {
            
            let alert = UIAlertController(title: "Pls! Activate the GPS", message:
                "Picpoint cannot work without it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            self.present(alert, animated: true, completion: nil)
            
        } else {
        requestGuest()
        }
    }
    //Petición con la api
    func requestLogin()
    {
        self.showSpinner(onView: self.view)
        if Connectivity.isConnectedToInternet() {
            request(Constants.url+"login",
                    method: .post,
                    parameters: ["email":emailFieldL.text!, "password":passwordFieldL.text!],
                    encoding: URLEncoding.httpBody).responseJSON { (replyQuestL) in
                        self.removeSpinner()
                        print(replyQuestL.response?.statusCode ?? 0)
                        print(replyQuestL.result.value!)
                        
                        var jsonResponse = replyQuestL.result.value as! [String:Any]
                        
                        if((replyQuestL.response?.statusCode) != 200)
                        {
                            let alert = UIAlertController(title: "\(jsonResponse["message"] ?? "email") ", message:
                                "Try it again", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "ok", style:
                                .cancel, handler: { (accion) in
                                    
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        if((replyQuestL.response?.statusCode) == 200)
                        {
                            UserDefaults.standard.set(jsonResponse["token"]!, forKey: "token")
                            UserDefaults.standard.set(jsonResponse["user_id"]!, forKey: "user_id")
                            UserDefaults.standard.set(jsonResponse["role_id"]!, forKey: "role_id")
                            
                            print(UserDefaults.standard.string(forKey: "token")!)
                            self.performSegue(withIdentifier: "loginOK", sender: nil)
                        }
            }
        }else{
            let alert = UIAlertController(title: "No connection", message:
                "Try it again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
        }
    }
    //Petición del usuario sin registro
    func requestGuest()
    {
        self.showSpinner(onView: self.view)
        if Connectivity.isConnectedToInternet() {
            request(Constants.url+"guest",
                    method: .post,
                    encoding: URLEncoding.httpBody).responseJSON { (replyQuestGLL) in
                        self.removeSpinner()
                        switch replyQuestGLL.result {
                        case .success:
                            var jsonResponse = replyQuestGLL.result.value as! [String:Any]
                            if((replyQuestGLL.response?.statusCode) != 200)
                            {
                                let alert = UIAlertController(title: "\(jsonResponse["message"] ?? "default") ", message:
                                    "Try it again", preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "ok", style:
                                    .cancel, handler: { (accion) in}))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                var jsonResponse = replyQuestGLL.result.value as! [String:Any]
                                UserDefaults.standard.set(jsonResponse["token"]!, forKey: "token")
                                UserDefaults.standard.set(jsonResponse["role_id"]!, forKey: "role_id")
                                self.performSegue(withIdentifier: "loginOK", sender: nil)
                            }
                        case .failure(let error):
                            let alert = UIAlertController(title: "Ups! Something was wrong", message:
                                "Pls, try it later", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Settings", style:
                                .default, handler: { (accion) in
                                    UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                            }))
                            alert.addAction(UIAlertAction(title: "ok :(", style:
                                .cancel, handler: { (accion) in }))
                            self.present(alert, animated: true, completion: nil)
                        }
            }
        }else{
            let alert = UIAlertController(title: "Pls! Activate the internet", message:
                "Picpoint cannot work without it", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Settings", style:
                .default, handler: { (accion) in
                    UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString  )!, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "ok :(", style:
                .cancel, handler: { (accion) in }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Valida los datos.
    func validateInputs() -> Bool
    {
        if ((emailFieldL.text?.isEmpty)! || (passwordFieldL.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "There can be no empty fields", message:
                "Try it again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style:
                .cancel, handler: { (accion) in}))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //Esta función se encarga de ocultar el teclado
    @IBAction func textExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
