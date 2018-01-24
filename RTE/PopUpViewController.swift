//
//  PopUpViewController.swift
//  RTE
//
//  Created by Özcan AKKOCA on 12.06.2017.
//  Copyright © 2017 Özcan AKKOCA. All rights reserved.
// https://github.com/callmeed/ios-popup-experiments

import UIKit
import AVFoundation
import CoreData
import GoogleMobileAds //kütüphaneyi ekle

@available(iOS 10.0, *)

class PopUpViewController: UIViewController {
    
    @IBOutlet var panelView: UIView!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    
    
    var activityViewController:UIActivityViewController?
    var interstitial: GADInterstitial! // Interstitial tipinde reklam oluştur.
    var detailKey: String?
    var detailValue: String?
    var player : AVPlayer?
    var rTECategory:RTECategory?
    static var interstitialAdmobCount = 0

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    // MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        key.text = detailKey
        rTECategory = RTECategory()

        play((Any).self)
        
        favIconControl()
        intersitialAdmobCountControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button action(s)
    @IBAction func didTapOk(_ sender: AnyObject) {
        // TIP: If you're using a semi-transparent background (instead of clear)
        //      this looks better if you set animated to FALSE
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UI Configuration
    func configureUI() {
        // In order to have a transparent background and see through
        // to the presenting VC, these 2 settings are necessary on the view
        // TIP: you can also use a color with alpha such as UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        // You can also perform optional decorations such as round corners & shadows
        setRoundCorners()
        setDropShadow()
        setBorder()
    }
    
    func setRoundCorners() {
        panelView.layer.cornerRadius = 9
    }
    
    func setBorder() {
        panelView.layer.borderWidth = 3.0
        panelView.layer.borderColor = UIColor.white.cgColor
    }
    
    func setDropShadow() {
        panelView.layer.shadowColor = UIColor.black.cgColor
        panelView.layer.shadowOpacity = 0.5
        panelView.layer.shadowOffset = CGSize(width: 0, height: 2)
        panelView.layer.shadowRadius = 1.0
        
    }
    
    @IBAction func play(_ sender: Any) {
        playBtn.setImage(UIImage(named: "Pause.png"), for: .normal)

        let path = Bundle.main.path(forResource: detailValue, ofType:"mp3")!
        let url = URL(fileURLWithPath: path)
        
 
        player = AVPlayer(url: url)
        player?.play()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PopUpViewController.animationDidFinish(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    func animationDidFinish(_ notification: NSNotification) {
        playBtn.setImage(UIImage(named: "Play.png"), for: .normal)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    @IBAction func favori(_ sender: Any) {
        

        let entity = NSEntityDescription.entity(forEntityName: "RteDB", in: context)
        let request: NSFetchRequest<RteDB> = RteDB.fetchRequest()
        request.entity = entity
        
        let pred = NSPredicate(format: "(key = %@)", detailKey!)
        request.predicate = pred
        
        do {
            let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            print(results)

            // Kaydet
            if results.isEmpty == true {
                let rteDB = RteDB(context: context)
                rteDB.key = detailKey
                rteDB.value = detailValue
                
                
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                favBtn.setImage(UIImage(named: "Heart-Full.png"), for: .normal)
            } else {
                //silme
                for object in results {
                    context.delete(object as! NSManagedObject)
                    favBtn.setImage(UIImage(named: "Heart-Empty.png"), for: .normal)

                }
                
            }
            
        } catch let error {
            print(error)
            // Handle error
        }


    }
    
    @IBAction func share(_ sender: Any) {
//        let activityViewController = UIActivityViewController(
//            activityItems: ["ozcan" as NSString],
//            applicationActivities: nil)
//        
//        present(activityViewController, animated: true, completion: nil)
        let path = Bundle.main.path(forResource: detailValue, ofType:"mp3")!
        let url = URL(fileURLWithPath: path)
        let item: [Any] = [url] // URL path to where audio file is written to
        let avc = UIActivityViewController(activityItems: item, applicationActivities: nil)
        self.present(avc, animated: true)
    }
    
    @IBAction func random(_ sender: Any) {
        
        let rndNumber = randomNumber(MIN: 0, MAX: (rTECategory?.fullDataDict.allKeys.count)!)
        key.text = rTECategory?.fullDataDict.allKeys[rndNumber] as? String

        let path = Bundle.main.path(forResource: rTECategory?.fullDataDict.allValues[rndNumber] as? String, ofType:"mp3")!
        let url = URL(fileURLWithPath: path)
        
        
        //favori fonksiyonu için güncelleme yapıldı.
        detailKey = rTECategory?.fullDataDict.allKeys[rndNumber] as? String
        detailValue = rTECategory?.fullDataDict.allValues[rndNumber] as? String
        
        
        player = AVPlayer(url: url)
        player?.play()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PopUpViewController.animationDidFinish(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    
    // Fav icon Core Data kontrolü
    func favIconControl() {
        let entity = NSEntityDescription.entity(forEntityName: "RteDB", in: context)
        let request: NSFetchRequest<RteDB> = RteDB.fetchRequest()
        request.entity = entity
        
        let pred = NSPredicate(format: "(key = %@)", detailKey!)
        request.predicate = pred
        
        do {
            let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            if results.isEmpty == true {
                favBtn.setImage(UIImage(named: "Heart-Empty.png"), for: .normal)
                
            } else {
                favBtn.setImage(UIImage(named: "Heart-Full.png"), for: .normal)
                
            }
            
        } catch let error {
            print(error)
            // Handle error
        }
    }
    
    // MARK: - Game Logic
    
    fileprivate func startAdmob() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3678993859791859/9018378151") //Interstitial tipinde id yapıştır.
        let request = GADRequest()
        
        interstitial.load(request)
        
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector:#selector(PopUpViewController.runAdmob(_:)),
                             userInfo: nil,
                             repeats: true) // 1sn sonra ViewController.runAdmob(_:) methodunu çağır.
    }
    
    
    
    
    func runAdmob(_ timer: Timer) {
        interstitial.present(fromRootViewController: self) // Root da tam ekran olarak çalıştırır.
    }
    
    
    func intersitialAdmobCountControl() {
        if PopUpViewController.interstitialAdmobCount == 4 {
            startAdmob() // reklamı başlat
            PopUpViewController.interstitialAdmobCount = 0
        } else {
            PopUpViewController.interstitialAdmobCount += 1
        }
    }
 

    
}
