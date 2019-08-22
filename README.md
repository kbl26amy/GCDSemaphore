# GCD Group與GCD Semaphore 

----
## 目標
使用 [臺北市固定測速照相地點表 ](https://data.taipei/#/dataset/detail?id=745b8808-061f-4f5b-9a62-da1590c049a9)

> 
1. 利用 GCD Group 的特性，將三個 Response 的資料，同時 呈現在畫面上。
2. 利用 GCD Semaphore 的特性，將三個 Response 的資料，依照 offset 的順序，依序 呈現在畫面上。

----
## 
# GCD Group

**dispatchGroup.enter() 與 dispatchGroup.leave()**

> 在執行任務前下 enter() ，並在任務結束後下 leave()

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
        
> 三個任務都結束後，使用 dispatchGroup.notify(queue: .main) {} 讓文字出現在畫面上

    dispatchGroup.notify(queue: .main) {
            self.firstAdress.text = self.firstdata?.road
            self.firstSpeed.text = self.firstdata?.speed_limit
            self.secondLabel.text = self.seconddata?.road
            self.SecondSpeed.text = self.seconddata?.speed_limit
            self.thirdLabel.text = self.thirddata?.road
            self.thirdSpeed.text = self.thirddata?.speed_limit
        }
        
# GCD Semaphore 

**使用 semaphore.wait() 與 semaphore.signal()**

>讓文字依序出現在畫面上
        
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
        
![](https://github.com/kbl26amy/GCDSemaphore/blob/master/GCDpractice.gif?raw=true)
----
## Tips

發 API 的過程需進行的事情：

1. make request
2. send request
3. wait for request (Responce Time)
4. handle responce (Data -> Object) Parse Data

-------------------------

* Client  ->   Server : request time
* Client  <-   Server : responce time

* Group : 一次發三隻ＡＰＩ，只有花一次 responce time 的時間
搭配 concurrent queue 讓 ＡＰＰ 效率更高


* Semaphore ：Responce 回來之後將其卡住

----
## thanks
* [ Wuchiwei](https://github.com/Wuchiwei/iOS/tree/master/GC)
