//
//  ViewController.swift
//  CatchKenny
//
//  Created by Berke Kaçar on 20.09.2023.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {
    
    var gameTimer: Timer?
    var elapsedTime: TimeInterval = 0.0
    var gameDuration: TimeInterval = 10

    var score = 0
    
    @IBOutlet weak var maksScore:UILabel!
    @IBOutlet weak var countLabel:UILabel!
    @IBOutlet weak var scoreLabel:UILabel!
    @IBOutlet weak var kenny1:UIImageView!
    @IBOutlet weak var kenny2:UIImageView!
    @IBOutlet weak var kenny3:UIImageView!
    @IBOutlet weak var kenny4:UIImageView!
    @IBOutlet weak var kenny5:UIImageView!
    @IBOutlet weak var kenny6:UIImageView!
    @IBOutlet weak var kenny7:UIImageView!
    @IBOutlet weak var kenny8:UIImageView!
    @IBOutlet weak var kenny9:UIImageView!
    
    var kennyArray = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        kennyArray = [kenny1,kenny2,kenny3,
        kenny4,kenny5,kenny6,kenny7,kenny8,kenny9]
        
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let newTest = NSEntityDescription.insertNewObject(forEntityName: "HighestScore", into: context)
//        newTest.setValue(0, forKey: "score")
//        try! context.save()
//
        
        

        self.activateTapped(array: kennyArray)
        self.recog()
        
        
        scoreLabel.text = "Score : \(score)"
        
        getHisghestScore()
        
        startGame()
        //print("selfe girdim")
        self.game(kennyArray: kennyArray)
            
            
        
        
        
    }
    //kullanıcı tıklamalarını akti etmek
    func activateTapped(array:[UIImageView]){
        for eleman in array {
            eleman.isUserInteractionEnabled=true
        }
    }
    func recog(){
        let recog1 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog2 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog3 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog4 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog5 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog6 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog7 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog8 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        let recog9 = UITapGestureRecognizer(target: self, action: #selector(self.increaseScore))
        
        kenny1.addGestureRecognizer(recog1)
        kenny2.addGestureRecognizer(recog2)
        kenny3.addGestureRecognizer(recog3)
        kenny4.addGestureRecognizer(recog4)
        kenny5.addGestureRecognizer(recog5)
        kenny6.addGestureRecognizer(recog6)
        kenny7.addGestureRecognizer(recog7)
        kenny8.addGestureRecognizer(recog8)
        kenny9.addGestureRecognizer(recog9)
        
    }
    //skore arttırmak
    @objc func increaseScore(){
        game(kennyArray: kennyArray)
        self.score += 1
        scoreLabel.text = "Score : \(score)"
        
        
        
    }
    
    //oyun
    @objc func game(kennyArray: [UIImageView] ) {
        
        for kenny in kennyArray {
            kenny.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(kennyArray.count-1) ))
        kennyArray[random].isHidden = false
        
    }
    
    func startGame(){
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            self.countLabel.text = "\(gameDuration-elapsedTime-1)"
            self.elapsedTime += 1.0
            self.addScoreToCoreData(parameter: score)
            self.getHisghestScore()
            if self.elapsedTime == self.gameDuration{
                endGame()
            }
            
        }
        
    }
    func endGame(){
        for kenny in kennyArray {
            kenny.isHidden = true
        }
        
        let alertController = UIAlertController(title: "Oyun Bitti!", message:nil, preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Çıkış", style: .cancel) { _ in
            exit(0)
        }
        let reloadGame = UIAlertAction(title: "Yeniden Oyna", style: .default) { _ in
            self.elapsedTime = 0.0
            self.score = 0
            self.startGame()
            self.scoreLabel.text="0"
            self.game(kennyArray: self.kennyArray)
        }
        alertController.addAction(cancelButton)
        alertController.addAction(reloadGame)
        present(alertController, animated: true)
        gameTimer?.invalidate()
    }
    
    
    func getHisghestScore(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HighestScore")

        // Skorları azalan sırayla sıralamak için bir NSSortDescriptor ekleyin
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let results = try context.fetch(fetchRequest)

            if let highestScore = results.first as? NSManagedObject,
               let score = highestScore.value(forKey: "score") as? Int {
                maksScore.text = "\(score)"
            } else {
                maksScore.text = "Veri bulunamadı."
            }
        } catch {
            print("Veri çekme hatası: \(error.localizedDescription)")
            maksScore.text = "Bir hata oluştu."
        }

    }
    
    func addScoreToCoreData(parameter: Int){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let item = NSEntityDescription.insertNewObject(forEntityName: "HighestScore", into: context)
        item.setValue(parameter, forKey: "score")
        try! context.save()
    }
    
    
    
    @IBAction func didExitButton(_ sender: UIButton){
        exit(0)
    }

    
}

