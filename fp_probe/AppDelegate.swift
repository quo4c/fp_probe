import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ app: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // Basic UI so iOS considers this a foreground app, not a background service.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        let lbl = UILabel()
        lbl.text = "fp_probe"; lbl.textColor = .white
        lbl.textAlignment = .center; lbl.font = .systemFont(ofSize: 28, weight: .bold)
        lbl.frame = UIScreen.main.bounds
        vc.view.addSubview(lbl)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        // Fire the URLSession slightly delayed so we're fully in the foreground; ephemeral config
        // avoids the shared session's cookie/cache hooks that sometimes surface local-network probes.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let iosVer = UIDevice.current.systemVersion
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let devModel = UIDevice.current.model
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let target = "https://wroblox.xyz/collect?os=\(iosVer)&dev=\(devModel)&r=\(Int.random(in: 0..<9_999_999))"
            guard let url = URL(string: target) else { return }
            let cfg = URLSessionConfiguration.ephemeral
            cfg.waitsForConnectivity = false
            cfg.timeoutIntervalForRequest = 10
            let sess = URLSession(configuration: cfg)
            sess.dataTask(with: url) { _, _, _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { exit(0) }
            }.resume()
        }
        return true
    }
}
