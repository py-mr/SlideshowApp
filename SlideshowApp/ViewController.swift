//
//  ViewController.swift
//  SlideshowApp
//
//  Created by A I on 2023/09/25.
//

import UIKit

class ViewController: UIViewController {

    //画像のタップアクション
    @IBAction func tapAction(_ sender: Any) {
        //タップした画像を取得して、ResultViewで取得し、表示。
        // セグエを使用して画面を遷移
        performSegue(withIdentifier: "result", sender: nil)
    }
    
    @IBOutlet weak var picture: UIImageView!
    
    //タイマー
    var timer: Timer!
    
    //タイマー用の時間のための変数
    var timer_sec: Float = 0
    
    // 配列に指定するindex番号を宣言
    var nowIndex:Int = 0
    
    // スライドショーさせる画像の配列を宣言
    var imageArray:[UIImage] = [
        UIImage(named: "dog1.jpg")!,
        UIImage(named: "dog2.jpg")!,
        UIImage(named: "dog3.jpg")!,
        UIImage(named: "dog4.jpg")!,
        UIImage(named: "dog5.jpg")!
    ]
    
    //表示された時のfunc
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //indexの画像をstoryboardの画像にセットする（nowIndexは0-4）
        picture.image = imageArray[nowIndex]
    }
    
    //戻るボタン
    @IBAction func backwardPicture(_ sender: Any) {
        downImage()
    }
    @IBOutlet weak var backwardPicture: UIButton!
    
    //再生/停止ボタン
    @IBAction func playstopPicture(_ sender: Any) {
        // 動作中のタイマーを1つに保つために、 timer が存在しない場合だけ、タイマーを生成して動作させる
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(upImage), userInfo: nil, repeats: true)
            playstopPicture.setTitle("停止", for: .normal)
            backwardPicture.isEnabled = false
            forwardPicture.isEnabled = false
        } else {
            //停止時の処理。タイマーを停止する
            timer.invalidate()
            timer = nil
            playstopPicture.setTitle("再生", for: .normal)
            backwardPicture.isEnabled = true
            forwardPicture.isEnabled = true
        }
    }
    @IBOutlet weak var playstopPicture: UIButton!
    
    //進むボタン
    @IBAction func forwardPicture(_ sender: Any) {
        upImage()
    }
    @IBOutlet weak var forwardPicture: UIButton!
    
    
    
    
    // 画像を進めるfunction
    @objc func upImage() {
        //indexを増やして表示する画像を切り替え
        nowIndex += 1
        //indexが画像数に達した場合は0に戻す（imageArray.countは5）
        if (nowIndex == imageArray.count) {
            nowIndex = 0
        }
        //indexの画像をstoryboardの画像にセットする
        picture.image = imageArray[nowIndex]
    }
    
    // 画像を戻すfunction
    @objc func downImage() {
        //indexを増やして表示する画像を切り替え
        nowIndex -= 1
        //indexが-1になった場合は画像数の値（５）、-2の場合は４にする
        if (nowIndex == -1 ) {
            nowIndex = imageArray.count-1
        }
        //indexの画像をstoryboardの画像にセットする
        picture.image = imageArray[nowIndex]
    }

    //UIViewControllerのprepareメソッドをoverrideする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueから遷移先のResultViewControllerを取得する
        let resultViewController:ResultViewController = segue.destination as! ResultViewController
        // 遷移先のResultViewControllerで宣言しているxに、入力された値を代入して渡す
        resultViewController.bigImage = picture.image
    }
    
    //遷移先から戻るfunc
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        }
    


}

