
import UIKit
import Alamofire

class SpotCommentsViewController: UIViewController {

    @IBOutlet weak var commentsInputText: UITextView!
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load!")
        
    }

    @IBAction func sendCommentButton(_ sender: Any) {
        print("boton pulsado enviar comentario")
    }
    
}
