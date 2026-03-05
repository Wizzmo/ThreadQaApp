import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    var user : User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        getUser()
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cardView.layer.cornerRadius = 12
        cardView.layer.borderColor = UIColor(cgColor: #colorLiteral(red: 0.06274509804, green: 0.4470588235, blue: 0.7294117647, alpha: 1).cgColor).cgColor
        cardView.layer.borderWidth = 2.0
        self.userImage.layer.cornerRadius=self.userImage.frame.size.width/2
        self.userImage.clipsToBounds = true
        self.userImage.layer.borderColor = UIColor(cgColor: #colorLiteral(red: 0.06274509804, green: 0.4470588235, blue: 0.7294117647, alpha: 1).cgColor).cgColor
        self.userImage.layer.borderWidth = 2
        
    }
    
    func getUser()
    {
        guard let userRequest = NetworkHelper.createRequest(url: BASE_URL + PERSON, method: "GET") else {
            return
        }
        
        URLSession.shared.dataTask(with: userRequest){
            (data, response, error) in
            guard let Data = data, error==nil
            else
            {
                print(error as Any)
                return
            }
            if let httpStatus = (response as? HTTPURLResponse)
            {
                if(httpStatus.statusCode != 200)
                {
                    print(httpStatus.statusCode)
                    return
                }
            }
            DispatchQueue.main.async
            {
                self.extractData(data: Data)
            }
        }.resume()
        
    }
    func extractData(data: Data){
        print("Got data!")
        hideIndicator()
        let user1 = try? JSONDecoder().decode(Result2.self, from: data)
        guard let decodedUser = user1 else {
            return
        }
        print(decodedUser)
        self.user = decodedUser.data
        firstNameLabel.text = user!.first_name
        lastNameLabel.text = user!.last_name
        emailLabel.text = user!.email
        
        userImage!.image = Downloader.downloadImageWithURL(url: user!.avatar)
        print(user!.first_name)
        
    }
}
