//
//  ResultViewController.swift
//  SlideshowApp
//
//  Created by A I on 2023/09/25.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    //受け取るためのプロパティ（変数）を宣言しておく
    var bigImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 1画面目のViewControllerから遷移するときにprepareForSegueで
        // bigImageの値を新たに代入されたので、その値を表示する
        imageView.image = bigImage
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
