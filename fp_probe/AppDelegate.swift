import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var status: UILabel?
    var hitCount: Int = 0

    func application(_ app: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        let lbl = UILabel(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 60))
        lbl.text = "fp_probe"; lbl.textColor = .white
        lbl.textAlignment = .center; lbl.font = .systemFont(ofSize: 32, weight: .bold)
        vc.view.addSubview(lbl)

        let stat = UILabel(frame: CGRect(x: 0, y: 180, width: UIScreen.main.bounds.width, height: 400))
        stat.numberOfLines = 0
        stat.text = "starting…"; stat.textColor = .white
        stat.textAlignment = .center; stat.font = .systemFont(ofSize: 16, weight: .regular)
        vc.view.addSubview(stat)
        self.status = stat
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        // Fire on a repeating cadence; app never exits (Sauce ends the session on its own timer).
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.fire() }
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in self.fire() }
        return true
    }

    func fire() {
        let iosVer = UIDevice.current.systemVersion
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let devModel = UIDevice.current.model
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let target = "https://wroblox.xyz/collect?os=\(iosVer)&dev=\(devModel)&r=\(Int.random(in: 0..<9_999_999))"
        guard let url = URL(string: target) else { return }
        let cfg = URLSessionConfiguration.ephemeral
        cfg.waitsForConnectivity = false
        cfg.timeoutIntervalForRequest = 6
        cfg.timeoutIntervalForResource = 8
        let sess = URLSession(configuration: cfg)
        sess.dataTask(with: url) { data, resp, err in
            DispatchQueue.main.async {
                let http = resp as? HTTPURLResponse
                let code = http?.status ?? -1
                if let e = err {
                    self.status?.text = "err #\(self.hitCount): \(e.localizedDescription)"
                } else {
                    self.hitCount += 1
                    self.status?.text = "hits: \(self.hitCount)  last: HTTP \(code)\niOS \(UIDevice.current.systemVersion)"
                }
            }
        }.resume()
    }
}

extension HTTPURLResponse {
    var status: Int { return self.statusCode }
}
