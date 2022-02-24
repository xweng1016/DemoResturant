//
//  NetAnimationView.swift
//  testlastfinal
//
//  Created by Xi Weng on 2022-02-22.
//


import UIKit

class NetAnimationView: UIView {
    // loading animation
    lazy var indicatorView : UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        indicatorView.backgroundColor = UIColor.gray
        indicatorView.layer.masksToBounds = true
        indicatorView.layer.cornerRadius = 6.0
        indicatorView.layer.borderWidth = 1.0
        indicatorView.layer.borderColor = UIColor.gray.cgColor
        indicatorView.frame = CGRect.init(x: (KScreenW - 100)/2.0, y: (KScreenH - 100)/2.0, width: 100, height: 100)
        return indicatorView
    }()
    
    static let share = NetAnimationView(frame: CGRect.init(x: 0, y: 0, width: KScreenW, height: KScreenH))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.3)
        self.addSubview(indicatorView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // show loading animation
    static func show(){
        DispatchQueue.main.async {
            //获取主窗口场景
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return }
            // 将NetAnimationView加到主窗口上
            window.addSubview(NetAnimationView.share)
            // 菊花开始转
            NetAnimationView.share.indicatorView.startAnimating()
        }
    }
    // stop loading animation
    static func diss(){
        DispatchQueue.main.async {
            NetAnimationView.share.removeFromSuperview()
            NetAnimationView.share.indicatorView.stopAnimating()
        }
        
    }
}

