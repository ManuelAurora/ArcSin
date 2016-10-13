
import Foundation
import UIKit

class NetworkRequestHandler
{
    private let sharedSession          = URLSession.shared
    private let deviceStatusIdentifier = DeviceStatusIdentifier.sharedInstance()
    private let deviceVersion          = UIDevice.current.systemVersion
    private let deviceModel            = UIDevice.current.model
    private let screen                 = UIScreen.main.bounds
    private let identifier             = UIDevice.current.identifierForVendor!.uuidString
    private var uid: String? {
        didSet {
            requestData(isRequestUid: true)
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
        
        var urlWithComponents = URLComponents(string: Network.url)
        
        urlWithComponents!.queryItems = [
            URLQueryItem(name: Network.URLParameterKey.appKey, value: Network.URLParameterValue.appKey),
            URLQueryItem(name: Network.URLParameterKey.packageName, value: Network.URLParameterValue.packageName),
            URLQueryItem(name: Network.URLParameterKey.appVersion, value: Network.URLParameterValue.appVersion),
            URLQueryItem(name: Network.URLParameterKey.deviceType, value: Network.URLParameterValue.deviceType),
            URLQueryItem(name: Network.URLParameterKey.deviceVersion, value: deviceVersion),
            URLQueryItem(name: Network.URLParameterKey.deviceModel, value: deviceModel),
            URLQueryItem(name: Network.URLParameterKey.screenHeight, value: String(describing: screen.height)),
            URLQueryItem(name: Network.URLParameterKey.screenWidth, value: String(describing: screen.width))
        ]
        
        if let location = deviceStatusIdentifier.location
        {
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let queryItemLat = URLQueryItem(name: Network.URLParameterKey.latitude, value: latitude)
            let queryItemLon = URLQueryItem(name: Network.URLParameterKey.longitude, value: longitude)
            
            urlWithComponents!.queryItems?.append(queryItemLat)
            urlWithComponents!.queryItems?.append(queryItemLon)
        }
        
        if isRequestUid
        {
            let queryUid = URLQueryItem(name: Network.URLParameterKey.uid, value: uid!)
            let querySessionDate = URLQueryItem(name: Network.URLParameterKey.lastSession, value: Network.URLParameterValue.lastSession)
            let contentType = URLQueryItem(name: Network.URLParameterKey.contentTypeId, value: Network.URLParameterValue.contentTypeId)
            let fromID = URLQueryItem(name: Network.URLParameterKey.fromId, value: Network.URLParameterValue.fromId)
            let max = URLQueryItem(name: Network.URLParameterKey.max, value: Network.URLParameterValue.max)
            
            urlWithComponents!.queryItems?.append(queryUid)
            urlWithComponents!.queryItems?.append(querySessionDate)
            urlWithComponents!.queryItems?.append(contentType)
            urlWithComponents!.queryItems?.append(fromID)
            urlWithComponents!.queryItems?.append(max)
        }
        else
        {
            let queryAiuid = URLQueryItem(name: Network.URLParameterKey.aiUid, value: identifier)
            
            urlWithComponents!.queryItems?.append(queryAiuid)
        }
        
        var request = URLRequest(url: urlWithComponents!.url!)
        
        request.httpBody = (urlWithComponents!.url!.absoluteString).data(using: .utf8)!
        
        request.httpMethod = "POST"
        
        print(String(data: request.httpBody!, encoding: .utf8))
        
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
                                _ = News(with: item)
                                
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
    
    func requestImage(with url: URL) -> UIImage {
        
        let imageData = try! Data(contentsOf: url)
        
        let image = UIImage(data: imageData)
        
        return image!
    }

}
