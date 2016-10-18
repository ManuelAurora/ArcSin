
import Foundation
import UIKit

class NetworkRequestHandler
{
    private let sharedSession          = URLSession.shared
    private let deviceStatusIdentifier = DeviceStatusIdentifier.sharedInstance()
    
    var allNews: [News]!    
    
    private var uid: String? {
        didSet {
            requestData(isRequestUid: false)
        }
    }
    
    class func sharedInstance() -> NetworkRequestHandler {
        struct Singleton
        {
            static let nrh = NetworkRequestHandler()
        }
        
        return Singleton.nrh
    }
    
    func requestData(isRequestUid: Bool) {
        
        var urlWithComponents = URLComponents()
        
        urlWithComponents.queryItems = [
            URLQueryItem(name: Network.URLParameterKey.appKey, value: Network.URLParameterValue.appKey),
            URLQueryItem(name: Network.URLParameterKey.packageName, value: Network.URLParameterValue.packageName),
            URLQueryItem(name: Network.URLParameterKey.deviceType, value: Network.URLParameterValue.deviceType),
            URLQueryItem(name: Network.URLParameterKey.deviceVersion, value: deviceStatusIdentifier.deviceVersion),
            URLQueryItem(name: Network.URLParameterKey.deviceModel, value: deviceStatusIdentifier.deviceModel),
            URLQueryItem(name: Network.URLParameterKey.screenHeight, value: String(describing: deviceStatusIdentifier.screen.height)),
            URLQueryItem(name: Network.URLParameterKey.screenWidth, value: String(describing: deviceStatusIdentifier.screen.width))
        ]
        
        if let location = deviceStatusIdentifier.location
        {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let queryItemLat = URLQueryItem(name: Network.URLParameterKey.latitude, value: latitude)
            let queryItemLon = URLQueryItem(name: Network.URLParameterKey.longitude, value: longitude)
            
            urlWithComponents.queryItems?.append(queryItemLat)
            urlWithComponents.queryItems?.append(queryItemLon)
        }
        
        if !isRequestUid
        {
            let queryUid = URLQueryItem(name: Network.URLParameterKey.uid, value: uid!)
            let querySessionDate = URLQueryItem(name: Network.URLParameterKey.lastSession, value: Network.URLParameterValue.lastSession)
            let contentType = URLQueryItem(name: Network.URLParameterKey.contentTypeId, value: Network.URLParameterValue.contentTypeId)
            let fromID = URLQueryItem(name: Network.URLParameterKey.fromId, value: Network.URLParameterValue.fromId)
            let max = URLQueryItem(name: Network.URLParameterKey.max, value: Network.URLParameterValue.max)
            let version = URLQueryItem(name: Network.URLParameterKey.appVersion, value: Network.URLParameterValue.appVersionOne)
            
            urlWithComponents.queryItems?.append(version)
            urlWithComponents.queryItems?.append(queryUid)
            urlWithComponents.queryItems?.append(querySessionDate)
            urlWithComponents.queryItems?.append(contentType)
            urlWithComponents.queryItems?.append(fromID)
            urlWithComponents.queryItems?.append(max)
        }
        else
        {
            let queryAiuid = URLQueryItem(name: Network.URLParameterKey.aiUid, value: deviceStatusIdentifier.identifier)
            let version = URLQueryItem(name: Network.URLParameterKey.appVersion, value: Network.URLParameterValue.appVersionOne)
            
            urlWithComponents.queryItems?.append(version)
            urlWithComponents.queryItems?.append(queryAiuid)
        }
        
        let urlString = isRequestUid ? Network.registerUrl : Network.getContentUrl
        
        var request = URLRequest(url: URL(string: urlString)!)
        
        request.httpBody = urlWithComponents.query!.data(using: .utf8)
        
        request.httpMethod = "POST"
        
        let task = sharedSession.dataTask(with: request) {
            
            (data, response, error) in
            
            guard data != nil else { return }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200
            {
                print("\(response)")
            }
            
            do
            {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                
                print(jsonData)
                
                if let responseData = jsonData["data"] as? [String: AnyObject]
                {
                    if isRequestUid
                    {
                        if let uid = responseData["UID"] as? String
                        {
                            self.uid = uid
                        }
                    }
                    else
                    {
                        if let content = responseData["content"] as? [[String: AnyObject]]
                        {
                            for item in content
                            {
                                if !self.allNews.contains(where: { news -> Bool in Int(news.id)  == item["id"] as! Int })
                                {
                                    _ = News(with: item)
                                    try! DataManager.sharedInstance().saveContext()
                                }
                            }
                        }
                    }
                }
            }
            catch let error
            {
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    func requestImage(with url: URL) -> UIImage? {
        
        do {
            let imageData = try Data(contentsOf: url)
            
            let image = UIImage(data: imageData)
            
            return image
        }
        catch let error {
            print(error)
        }
        
        return nil
    }

}
