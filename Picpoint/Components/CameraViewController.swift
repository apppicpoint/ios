import UIKit
import AVFoundation

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var backBtn: UIBarButtonItem!
    var image: UIImage?
    var imageName: String?
    var longitude: Double?
    var latitude: Double?
    var new: String?
    let utils = Utils()
    var imagePicker = UIImagePickerController() //Selector de imagenes para la galería
    
    override func viewDidLoad() {
        
        if new == "spot"{
            self.navigationItem.leftBarButtonItem = nil
        }
        else {
            self.navigationItem.leftBarButtonItem = backBtn
        }
        
        /*
         setupCaptureSession()
         setupDevice()
         setupInputOutput()
         setupPreviewLayer()
         startRunningCaptureSession() */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWill")
        showAlert()
    }
    
    func showAlert() {
        
        let alert = UIAlertController(title: "Select an option", message: "Select an option", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .savedPhotosAlbum)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) in
            //self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerControllerSourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    //Coge la foto
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.image = image // Coloca la imagen en el imageView
            imageName = UserDefaults.standard.string(forKey: "user_id")! + utils.randomString(length: 15)
            performSegue(withIdentifier: "previewImage", sender: self)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is PreviewImageViewController {
            let destination = segue.destination as! PreviewImageViewController
            
            print(imageName! , "en prepare clase CameraViewController")
            print(image! , "en prepare clase CameraViewController")
            
            destination.imageName = imageName
            destination.image = self.image!
            destination.new = self.new
            
            if new == "spot"{
                
                destination.longitude = longitude
                destination.latitude = latitude
            }
        }
    }
    
    @IBAction func backAct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goPreviewImage(_ sender: UIBarButtonItem) {
        //performSegue(withIdentifier: "previewImage", sender: sender)
    }
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        //performSegue(withIdentifier: "previewImage", sender: sender)
    }
    
    @IBAction func backFromToCamera(_ segue: UIStoryboardSegue) {
        
    }
    
    //    // Do any additional setup after loading the view.
    //    @IBAction func takePhotoFromGalelery(_ sender: UIButton) {
    //        /*if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
    //            imagePicker.delegate = self //Selecciona la propia vista como delegado
    //            imagePicker.sourceType = .savedPhotosAlbum;
    //            imagePicker.allowsEditing = false //Permite editar la foto
    //            self.present(imagePicker, animated: true, completion: nil)//Reserva la foto para usarla.
    //        }*/
    //    }
    
}
