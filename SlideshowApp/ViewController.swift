//
//  ViewController.swift
//  SlideshowApp
//
//  Created by A I on 2023/09/25.
//

import UIKit

class ViewController: UIViewController {

    //画像のタップアクション（https://seeku.hateblo.jp/entry/2016/07/02/175420）
    @IBAction func tapAction(_ sender: Any) {
        // セグエを使用して画面を遷移
        performSegue(withIdentifier: "result", sender: nil)
    }
    @IBAction func tapAction2(_ sender: Any) {
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
        UIImage(named: "dog5.jpg")!,
        UIImage(named: "dog6.jpg")!
    ]
    
    @objc func trimming (image: UIImage) -> UIImage {
        //https://www.yoheim.net/blog.php?q=20120503
        //切り抜く位置を指定するCGRectを作成する。
        //画像の中心部分を120*160で切り取る。
        var posX: CGFloat
        var posY: CGFloat
        var trimArea: CGRect
        if image.size.width > image.size.height*120/160 {
            posX = (image.size.width - image.size.height*120/160)/2
            posY = 0
            trimArea = CGRectMake(posX, posY, image.size.height*120/160, image.size.height)
        } else {
            posX = 0
            posY = (image.size.height - image.size.width*160/120)/2
            trimArea = CGRectMake(posX, posY, image.size.width, image.size.width*160/120)
        }
        // CoreGraphicsの機能を用いて、切り抜いた画像を作成する。
        var srcImageRef: CGImage
        var trimmedImageRef: CGImage
        var trimmedImage: UIImage
        srcImageRef = image.cgImage!
        trimmedImageRef = srcImageRef.cropping(to: trimArea)!
        //trimmedImage = trimmedImageRef as! UIImage
        trimmedImage = UIImage(cgImage: trimmedImageRef)
        return trimmedImage
    }
    
    @IBOutlet weak var scroll: UIScrollView!
    
    //let scrollView = UIScrollView()
    private var offsetX: CGFloat = 0
    
    let wid :Double = 120.0
    let hei :Double = 160.0
    
    //表示された時のfunc
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //indexの画像をstoryboardの画像にセットする（nowIndexは0-4）
        picture.image = imageArray[nowIndex]
        
        // スクロールビューを追加
        setUpImageView()
        self.view.addSubview(scroll)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //戻るボタン
    @IBAction func backwardPicture(_ sender: Any) {
        downImage()
        revscrollPage()
    }
    @IBOutlet weak var backwardPicture: UIButton!
    
    //再生/停止ボタン
    @IBAction func playstopPicture(_ sender: Any) {
        // 動作中のタイマーを1つに保つために、 timer が存在しない場合だけ、タイマーを生成して動作させる
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(up), userInfo: nil, repeats: true)
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
        scrollPage()
    }
    @IBOutlet weak var forwardPicture: UIButton!
    
    
    //２枠とも画像を進める
    @objc func up() {
        upImage()
        scrollPage()
    }
    
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


    // imageArrayの要素分UIImageViewをscrollViewに並べる
    func setUpImageView() {
        //storyboardでScrollViewを追加したので下記不要
        //scroll.frame = CGRect(x: 100.0, y: 100.0, width: wid, height: hei)
        //scroll.contentSize = CGSize(width: wid * Double(imageArray.count)-1, height: hei)
        scroll.isPagingEnabled = true
        for i in 0 ..< imageArray.count {
            imageArray[i] = trimming(image: imageArray[i])
            let imageView = UIImageView(image: imageArray[i])
            imageView.frame = CGRect(x: wid * Double(i), y: 0.0, width: wid, height: hei)
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            scroll.addSubview(imageView)
        }
        scroll.contentSize = CGSize(width: wid * Double(imageArray.count), height: hei)
    }
    
    // offsetXの値を更新することでページを移動する
    @objc func scrollPage() {
        // 画面の幅分offsetXを移動
        self.offsetX += self.wid
        // 3ページ目まで移動したら1ページ目まで戻る
        if self.offsetX < self.wid * Double(imageArray.count) {
            UIView.animate(withDuration: 0.3) {
                self.scroll.contentOffset.x = self.offsetX
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.offsetX = 0
                self.scroll.contentOffset.x = self.offsetX
            }
        }
    }
    
    // offsetXの値を更新することでページを移動する
    @objc func revscrollPage() {
        // 画面の幅分offsetXを移動
        self.offsetX -= self.wid
        // -1ページ目まで移動したら6ページ目まで戻る
        if self.offsetX < 0 {
            UIView.animate(withDuration: 0.3) {
                self.offsetX = self.wid * (Double(self.imageArray.count)-1.0)
                self.scroll.contentOffset.x = self.offsetX
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.scroll.contentOffset.x = self.offsetX
            }
        }
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

