import UIKit

import UIKit

class Downloader {
    
    // Асинхронная загрузка изображения
    class func downloadImageWithURL(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            print("Invalid image URL: \(url)")
            completion(nil)
            return
        }
        
        print("DOWNLOADING IMAGE: \(url)")
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("IMAGE DOWNLOAD ERROR: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to create image from data")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            print("IMAGE DOWNLOADED: \(data.count) bytes")
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    // Синхронная версия (deprecated - не использовать!)
    @available(*, deprecated, message: "Use async version downloadImageWithURL(url:completion:) instead")
    class func downloadImageWithURL(url: String) -> UIImage {
        let data = NSData(contentsOf: NSURL(string: url)! as URL)
        return UIImage(data: data! as Data)!
    }
}

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, AddUserProtocolDelegate {
    
    var users = [User]()
    
    @IBOutlet weak var userView: UITableView!
    let itemsPerBatch = 15
    var currentRow: Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home Page"
        userView.dataSource = self
        userView.delegate = self
        
        print("HomeView загружен")
        print("ImageDownloader кеш настроен: \(ImageDownloader.shared.getCacheInfo())")
        
        getUsersList()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(users.count)
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User", for: indexPath) as! HomeTableViewCell
        let user = users[indexPath.row]
        
        cell.userName.text = "\(user.first_name)  \(user.last_name)"
        cell.userEmail.text = user.email
        
        // Настройка стиля изображения
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2
        cell.userImage.clipsToBounds = true
        cell.userImage.layer.borderColor = UIColor(cgColor: #colorLiteral(red: 0.06274509804, green: 0.4470588235, blue: 0.7294117647, alpha: 1).cgColor).cgColor
        cell.userImage.layer.borderWidth = 2
        
        // Загрузка изображения с помощью extension
        cell.userImage.loadImage(from: user.avatar)
        
        return cell
    }
    
    func getUsersList()
    {
        if !Utilities.isNetworkAvailable()
        {
            showAlert(title: "No network", message: "No Network. Please check your connection.")
            return
        }
        
        showIndicator(message: "getting users")
        
        // Создание запроса
        guard let userRequest = NetworkHelper.createRequest(url: BASE_URL + USERS, method: "GET") else {
            hideIndicator()
            showAlert(title: "Error", message: "Failed to create request")
            return
        }
        
        print("HTTP USERS REQUEST")
        print("URL: \(userRequest.url?.absoluteString ?? "N/A")")
        print("METHOD: GET")
        print("HEADERS: \(userRequest.allHTTPHeaderFields ?? [:])")
        
        // Выполнение запроса
        URLSession.shared.dataTask(with: userRequest) { [weak self] data, response, error in
            
            print("HTTP USERS RESPONSE")
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusEmoji = httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 ? "✅" : "❌"
                print("\(statusEmoji) STATUS: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("DATA SIZE: \(data.count) bytes")
                }
            }
            
            DispatchQueue.main.async {
                self?.handleUsersResponse(data: data, response: response, error: error)
            }
        }.resume()
    }
    
    private func handleUsersResponse(data: Data?, response: URLResponse?, error: Error?) {
        hideIndicator()
        
        guard let data = data, error == nil else {
            print("USERS ERROR: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("USERS HTTP ERROR: \(httpStatus.statusCode)")
            return
        }
        
        extractData(data: data)
    }
    
    func extractData(data: Data){
        print("PROCESSING USERS DATA...")
        
        do {
            let users = try JSONDecoder().decode(Result.self, from: data)
            self.users = users.data
            print("Successfully parsed \(users.data.count) users")
            userView.reloadData()
        } catch {
            print("JSON decoding error: \(error.localizedDescription)")
            
            // Попытка вывести сырые данные для отладки
            if let rawString = String(data: data, encoding: .utf8) {
                print("RAW USERS DATA: \(rawString)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue .identifier == "UserDetailSegue"
        {
            let userDetailViewController = segue.destination as!
            UserDetailViewController
            
            let indexPath = userView.indexPathForSelectedRow
            
            let userToSendToSecondView = users[indexPath!.row]
            
            userDetailViewController.user = userToSendToSecondView
        }
        
        if segue.identifier == "AddUserSegue"
        {
            let addUserController = segue.destination as!
            AddNewUserViewController
            addUserController.addUserDelegate = self
        }
    }
    func CancelAddingUser(_ controller: AddNewUserViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    func AddNewUser(_ controller: AddNewUserViewController, user: User) {
        users.insert(user, at: 0)
        userView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
}
