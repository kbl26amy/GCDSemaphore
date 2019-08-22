
import UIKit

class ViewController: UIViewController {
    
    var firstdata: SpeedLocate?
    var seconddata: SpeedLocate?
    var thirddata:SpeedLocate?
    
    @IBOutlet weak var firstAdress: UILabel!
    @IBOutlet weak var firstSpeed: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var SecondSpeed: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdSpeed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupAPI()
//        getSemaphoreAPI()
    }
    
    let firstRequest = URLRequest(url: URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5012e8ba-5ace-4821-8482-ee07c147fd0a&limit=1&offset=0")!)
    let secondRequest = URLRequest(url: URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5012e8ba-5ace-4821-8482-ee07c147fd0a&limit=1&offset=10")!) 
    let thirdRequest = URLRequest(url: URL(string: "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=5012e8ba-5ace-4821-8482-ee07c147fd0a&limit=1&offset=20")!)
    
    
    func getGroupAPI() {

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: firstRequest, completionHandler: { (data, responce, error) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let firstdata = try decoder.decode(Data.self, from: data)
                self.firstdata = firstdata.result.results[0]
                print(self.firstdata as Any)
                
                 dispatchGroup.leave()
          
            } catch {
                print(error)
            }
            
        }).resume()
       
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: secondRequest, completionHandler: { (data, responce, error) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let seconddata = try decoder.decode(Data.self, from: data)
                self.seconddata = seconddata.result.results[0]
                print(self.seconddata as Any)
                
                dispatchGroup.leave()
        
            } catch {
                print(error)
            }
            
        }).resume()
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with:thirdRequest, completionHandler: { (data, responce, error) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            
            do {
                let thirddata = try decoder.decode(Data.self, from: data)
                self.thirddata = thirddata.result.results[0]
                print(self.thirddata as Any)
                
                dispatchGroup.leave()
                
            } catch {
                print(error)
            }
            
        }).resume()
        
        dispatchGroup.notify(queue: .main) {
            self.firstAdress.text = self.firstdata?.road
            self.firstSpeed.text = self.firstdata?.speed_limit
            self.secondLabel.text = self.seconddata?.road
            self.SecondSpeed.text = self.seconddata?.speed_limit
            self.thirdLabel.text = self.thirddata?.road
            self.thirdSpeed.text = self.thirddata?.speed_limit
        }
    }
    
    func getSemaphoreAPI() {
        
        let semaphore = DispatchSemaphore(value: 1)
        let loadingQueue = DispatchQueue.global()
        loadingQueue.async {
            semaphore.wait()
            URLSession.shared.dataTask(with: self.firstRequest, completionHandler: { (data, responce, error) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let firstdata = try decoder.decode(Data.self, from: data)
                self.firstdata = firstdata.result.results[0]
                print(self.firstdata as Any)
                semaphore.signal()
            DispatchQueue.main.async {
                self.firstAdress.text = self.firstdata?.road
                self.firstSpeed.text = self.firstdata?.speed_limit
                }
               
            } catch {
                print(error)
            }
            
        }).resume()
            
        }
  
        loadingQueue.async {
            semaphore.wait()
            URLSession.shared.dataTask(with: self.secondRequest, completionHandler: { (data, responce, error) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let seconddata = try decoder.decode(Data.self, from: data)
                self.seconddata = seconddata.result.results[0]
                print(self.seconddata as Any)
                
                  semaphore.signal()
                     DispatchQueue.main.async {
                    self.secondLabel.text = self.seconddata?.road
                    self.SecondSpeed.text = self.seconddata?.speed_limit
                }
             
            } catch {
                print(error)
            }
            
        }).resume()
        }
        
        loadingQueue.async {
            semaphore.wait()
            URLSession.shared.dataTask(with:self.thirdRequest, completionHandler: { (data, responce, error) in
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let thirddata = try decoder.decode(Data.self, from: data)
                self.thirddata = thirddata.result.results[0]
                print(self.thirddata as Any)
                
                semaphore.signal()
                DispatchQueue.main.async {
                    self.thirdLabel.text = self.thirddata?.road
                    self.thirdSpeed.text = self.thirddata?.speed_limit
                }
     
            } catch {
                print(error)
            }
            
        }).resume()
    }
        
  }
    
}

