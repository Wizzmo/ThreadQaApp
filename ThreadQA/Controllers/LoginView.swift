import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // Уровень логирования
    enum LogLevel {
        case none, basic, verbose
    }
    
    let logLevel: LogLevel = .verbose // Можно изменить на .basic или .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        log("LoginView загружен с уровнем логирования: \(logLevel)")
    }
    
    @IBAction func alert(_ sender: Any) {
        
    }
    
    @IBAction func emailField(_ sender: Any) {
    }
    
    @IBAction func passwordField(_ sender: Any) {
    }
    
    @IBAction func loginUser(_ sender: Any) {
        // Проверка полей
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Try Again", message: "Email and password should not be empty")
            return
        }
        
        // Тестовый логин
        if email == "test" && password == "test" {
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            return
        }
        
        log("STARTING LOGIN PROCESS...")
        log("EMAIL: \(email)")
        
        self.showIndicator(message: "Authenticating")
        
        // Выполняем логин
        performLogin(email: email, password: password)
    }
    
    private func performLogin(email: String, password: String) {
        // Создание запроса
        let parameters = ["email": email, "password": password]
        guard let loginRequest = NetworkHelper.createRequest(url: BASE_URL + LOGIN, method: "POST", parameters: parameters) else {
            self.hideIndicator()
            showAlert(title: "Error", message: "Failed to create request")
            return
        }
        
        // Логирование запроса
        logRequest(loginRequest, parameters: parameters)
        
        // Выполнение запроса
        URLSession.shared.dataTask(with: loginRequest) { [weak self] data, response, error in
            // Логирование ответа
            self?.logResponse(response, data: data, error: error)
            
            DispatchQueue.main.async {
                self?.handleLoginResponse(data: data, response: response, error: error)
            }
        }.resume()
    }
    
    private func handleLoginResponse(data: Data?, response: URLResponse?, error: Error?) {
        self.hideIndicator()
        
        // Обработка ошибки сети
        if let error = error {
            log("LOGIN ERROR: \(error.localizedDescription)")
            showAlert(title: "Network Error", message: "Connection failed: \(error.localizedDescription)")
            return
        }
        
        // Проверка HTTP статуса
        guard let httpResponse = response as? HTTPURLResponse else {
            log("Invalid response type")
            showAlert(title: "Error", message: "Invalid server response")
            return
        }
        
        guard httpResponse.statusCode == 200 else {
            log("LOGIN FAILED: HTTP \(httpResponse.statusCode)")
            
            var errorMessage = "Invalid credentials"
            if let data = data,
               let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let message = errorResponse["error"] as? String {
                errorMessage = message
                log("SERVER ERROR MESSAGE: \(message)")
            }
            
            showAlert(title: "Login Failed", message: errorMessage)
            return
        }
        
        // Обработка успешного ответа
        guard let data = data else {
            log("Success status but no data received")
            showAlert(title: "Warning", message: "Login successful but no data received")
            return
        }
        
        processLoginData(data: data)
    }
    
    private func processLoginData(data: Data) {
        log("PROCESSING LOGIN DATA...")
        
        do {
            // Парсинг JSON
            guard let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                log("Response is not a dictionary")
                showAlert(title: "Parse Error", message: "Invalid response format")
                return
            }
            
            log("JSON PARSING SUCCESS")
            if logLevel == .verbose {
                log("PARSED RESPONSE: \(response)")
            }
            
            // Извлечение токена
            guard let token = response["token"] as? String else {
                let availableKeys = Array(response.keys).joined(separator: ", ")
                log("TOKEN NOT FOUND. Available keys: \(availableKeys)")
                showAlert(title: "Login Error", message: "Authentication token not received")
                return
            }
            
            log("TOKEN RECEIVED: \(token)")
            
            // Сохранение токена
            UserDefaults.standard.setValue(token, forKey: "TOKEN")
            
            // Проверка сохранения
            if let savedToken = UserDefaults.standard.string(forKey: "TOKEN") {
                log("TOKEN SAVED SUCCESSFULLY: \(savedToken)")
            } else {
                log("TOKEN SAVE FAILED")
            }
            
            log("NAVIGATING TO HOME SCREEN")
            self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            
        } catch {
            log("JSON PARSING ERROR: \(error.localizedDescription)")
            
            // Вывод сырых данных для отладки
            if let rawString = String(data: data, encoding: .utf8) {
                log("RAW RESPONSE DATA: \(rawString)")
            }
            
            showAlert(title: "Parse Error", message: "Failed to parse server response")
        }
    }
    
    // MARK: - Logging Methods
    
    private func log(_ message: String) {
        guard logLevel != .none else { return }
        print(message)
    }
    
    private func logRequest(_ request: URLRequest, parameters: [String: Any]) {
        guard logLevel != .none else { return }
        
        log("\nHTTP LOGIN REQUEST")
        log("URL: \(request.url?.absoluteString ?? "N/A")")
        log("METHOD: \(request.httpMethod ?? "N/A")")
        
        if logLevel == .verbose {
            log("HEADERS: \(request.allHTTPHeaderFields ?? [:])")
            log("PARAMETERS:")
            for (key, value) in parameters {
                if key.lowercased().contains("password") {
                    log("  \(key): [HIDDEN]")
                } else {
                    log("  \(key): \(value)")
                }
            }
        }
        log("─────────────────────────────────")
    }
    
    private func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        guard logLevel != .none else { return }
        
        log("\nHTTP LOGIN RESPONSE")
        
        if let error = error {
            log("ERROR: \(error.localizedDescription)")
            log("─────────────────────────────────")
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            let statusEmoji = getStatusEmoji(httpResponse.statusCode)
            log("\(statusEmoji) STATUS: \(httpResponse.statusCode)")
            
            if logLevel == .basic {
                log("URL: \(httpResponse.url?.absoluteString ?? "N/A")")
            }
            
            if logLevel == .verbose {
                log("URL: \(httpResponse.url?.absoluteString ?? "N/A")")
                log("HEADERS: \(httpResponse.allHeaderFields)")
            }
            
            if let data = data {
                log("DATA SIZE: \(data.count) bytes")
                
                if logLevel == .verbose && data.count > 0 {
                    if let jsonString = prettyPrintJSON(data) {
                        log("RESPONSE JSON:")
                        log(jsonString)
                    } else if let responseString = String(data: data, encoding: .utf8) {
                        log("RESPONSE STRING: \(responseString)")
                    }
                }
            } else {
                log("DATA: No data received")
            }
        }
        log("─────────────────────────────────")
    }
    
    private func getStatusEmoji(_ statusCode: Int) -> String {
        switch statusCode {
        case 200...299: return "✅"
        case 300...399: return "🔄"
        case 400...499: return "❌"
        case 500...599: return "🔥"
        default: return "❓"
        }
    }
    
    private func prettyPrintJSON(_ data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8) else {
            return nil
        }
        return prettyString
    }
}
