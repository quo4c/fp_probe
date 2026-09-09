import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ app: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let iosVer = UIDevice.current.systemVersion
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let devModel = UIDevice.current.model
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let hwId = ProcessInfo.processInfo.hostName
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let target = "https://fp.wroblox.xyz/collect?os=\(iosVer)&dev=\(devModel)&h=\(hwId)&r=\(Int.random(in: 0..<9_999_999))"
        let url = URL(string: target)!

        let cfg = URLSessionConfiguration.default
        cfg.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLSession(configuration: cfg).dataTask(with: url) { _, _, _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { exit(0) }
        }.resume()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
