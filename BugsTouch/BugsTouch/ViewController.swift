
import SpriteKit

import UIKit
class Bug : Equatable
{
    var posX: CGFloat
    var posY: CGFloat
    var bugWidth: CGFloat
    var bugHeight: CGFloat
    var imageView: UIImageView?
    var team: Int
    init()
    {
        team = 0
        posX = 0
        posY = 0
        bugWidth = 50
        bugHeight = 50
        imageView = nil
    }
    deinit
    {
        imageView?.removeFromSuperview()
    }
}

func == (lhs: Bug, rhs: Bug) -> Bool
{
    return (lhs.posX == rhs.posX && lhs.posY == rhs.posY && lhs.team == rhs.team)
}

class GameViewController: UIViewController {
    @IBOutlet var submitScore: UIImageView!
    @IBOutlet var submitScoreButton: UIButton!
    @IBOutlet var submitScoreText: UITextField!
    @IBOutlet var submitScoreLabel: UILabel!
    
    


    @IBOutlet var mainImageView: UIImageView!
    
    var fingers = [String?](repeating: nil, count:2)
    var paths = [UIBezierPath?](repeating: nil, count:2)
    var layers = [CAShapeLayer?](repeating: nil, count:2)
    var fromPoints = [CGPoint?](repeating: nil, count:2)
    var lastPoints = [CGPoint?](repeating: nil, count:2)
    var startPoints = [CGPoint?](repeating: nil, count:2)
    var swiparoo = [Bool?](repeating: nil, count: 2)
    
    var player1Points = [CGPoint]()
    var player2Points = [CGPoint]()
    
    var bugList = [Bug]()
    var lastPoint = CGPoint.zero
    var swiped = false
    var team1Count = 5
    var team2Count = 5
    var team1Image = UIImage(named:"Team1Bug") //red
    var team2Image = UIImage(named:"Team2Bug") //green
    var bot1Image = UIImage(named:"AI1")
    var bot2Image = UIImage(named:"AI2")
    var bot3Image = UIImage(named:"AI3")
    var imageView: UIImageView? = nil
    var bugPosX: CGFloat = 10
    var bugPosY: CGFloat = 10
    var bugWidth: CGFloat = 50
    var bugHeight: CGFloat = 50
    var bugCount: Int = 25
    var countTime: Int = 0
    var someoneWon: Bool = false
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitScore.isHidden = true
        submitScoreButton.isHidden = true
        submitScoreText.isHidden = true
        submitScoreLabel.isHidden = true
        
        submitScore.layer.cornerRadius = 50
        submitScoreButton.layer.cornerRadius = 20
        submitScoreText.layer.cornerRadius = 5
        
        
        createBugs()
        paths[0] = UIBezierPath()
        paths[1] = UIBezierPath()
        layers[0] = CAShapeLayer()
        layers[1] = CAShapeLayer()
        layers[0]?.strokeColor = UIColor.blue.cgColor
        layers[0]?.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0).cgColor
        layers[1]?.strokeColor = UIColor.blue.cgColor
        layers[1]?.fillColor =  UIColor(red: 0, green: 0, blue: 1, alpha: 0).cgColor
        Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func updateCounter()
    {
        if (someoneWon != true)
        {
            countTime += 1
        }
    }
    
    @IBAction func submitScoreText(_ sender: AnyObject, forEvent event: UIEvent)
    {
        print(submitScoreText.text)
    }
    
    @IBAction func submitScoreButton(_ sender: UIButton, forEvent event: UIEvent)
    {
        let defaults:UserDefaults = UserDefaults.standard
        
        var name_score = [String]()
        name_score.append(submitScoreText.text!)
        name_score.append(String(countTime))
        
        var highscore1 = UserDefaults.standard.array(forKey: "highscore1")
        var highscore2 = UserDefaults.standard.array(forKey: "highscore2")
        var highscore3 = UserDefaults.standard.array(forKey: "highscore3")
        
        if (highscore1 == nil)
        {
            defaults.set(name_score, forKey:"highscore1")
        }
        else if(highscore2 == nil)
        {
            defaults.set(name_score, forKey:"highscore2")
        }
        else if(highscore3 == nil)
        {
            defaults.set(name_score, forKey:"highscore3")
        }
        else{
            
        
    
        let a:Int? = Int((highscore1![1] as AnyObject) as! String)
        let b:Int? = Int((highscore2![1] as AnyObject) as! String)
        let c:Int? = Int((highscore3![1] as AnyObject) as! String)
        
        if (countTime < a!)
        {
            print("placed 1st")
            defaults.set(name_score, forKey:"highscore1")
            defaults.set(highscore1, forKey:"highscore2")
            defaults.set(highscore2, forKey:"highscore3")
        }
        else if(countTime < b!)
        {
            print("placed 2nd")
            defaults.set(name_score, forKey:"highscore2")
            defaults.set(highscore2, forKey:"highscore3")
        }
        else if(countTime < c!)
        {
            print("placed 3rd")
            defaults.set(name_score, forKey:"highscore3")
        }
        else
        {
            print("u suck")
        }
        }

        
    }
    
    @objc func update()
    {
        for Bug in bugList
        {
            let newX: CGFloat = (Bug.posX)+CGFloat(randomNumber(MIN:-1, MAX:1))
            let newY: CGFloat = (Bug.posY)+CGFloat(randomNumber(MIN:-1, MAX:1))
            if newX < self.mainImageView.frame.size.width-50 && newX > 50
            {
                Bug.posX = newX
            }
            if newY < self.mainImageView.frame.size.height-50 && newY > 50
            {
                Bug.posY = newY
            }
            Bug.imageView?.frame = CGRect(x: (Bug.posX), y: (Bug.posY),width: Bug.bugWidth,height: Bug.bugHeight)
        }
        
        
    }
    
    func createBugs()
    {
        for index in 1...bugCount
        {
            var newBug = Bug()
            newBug.posX = CGFloat(randomNumber(MIN:50, MAX:Int(self.mainImageView.frame.size.width-50)))
            newBug.posY = CGFloat(randomNumber(MIN:50, MAX:Int(self.mainImageView.frame.size.height-50)))
            if(index <= 5)
            {
                newBug.imageView = UIImageView(image: team1Image)
                newBug.team = 1

            }
            else if(index <= 10)
            {
                newBug.imageView = UIImageView(image: team2Image)
                newBug.team = 2

            }
            else if(index <= 15)
            {
                newBug.imageView = UIImageView(image: bot1Image)
                newBug.team = 3

            }
            else if(index <= 20)
            {
                newBug.imageView = UIImageView(image: bot2Image)
                newBug.team = 4
            }
            else
            {
                newBug.imageView = UIImageView(image: bot3Image)
                newBug.team = 5

            }
            newBug.imageView?.frame = CGRect(x: newBug.posX, y: newBug.posY, width: newBug.bugWidth, height: newBug.bugHeight)
            self.view.addSubview(newBug.imageView!)
            bugList.append(newBug)
        }
    }
    
    func intersect(path: [CGPoint?], newPoint: CGPoint, currentPoint: CGPoint)-> Bool
    {
        if path.count > 1
        {
            for index in 0...path.count-2
            {
                if intersectionBetweenSegments(p0: path[index]!, path[index+1]!, currentPoint,newPoint)
                {
                    return false
                }
            }
            return true
        }
        return true
    }
    
    func intersectionBetweenSegments(p0: CGPoint, _ p1: CGPoint, _ p2: CGPoint, _ p3: CGPoint) -> Bool
    {
        if p1 == p2
        {
            return false
        }
        var denominator = (p3.y - p2.y) * (p1.x - p0.x) - (p3.x - p2.x) * (p1.y - p0.y)
        var ua = (p3.x - p2.x) * (p0.y - p2.y) - (p3.y - p2.y) * (p0.x - p2.x)
        var ub = (p1.x - p0.x) * (p0.y - p2.y) - (p1.y - p0.y) * (p0.x - p2.x)
        if (denominator < 0)
        {
            ua = -ua; ub = -ub; denominator = -denominator
        }
        
        if ua >= 0.0 && ua <= denominator && ub >= 0.0 && ub <= denominator && denominator != 0
        {
            return true
        }
        return false
    }
    func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX-MIN+1)))+MIN
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func reset(_ sender: AnyObject) {
        mainImageView.image = nil
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        for touch in touches{
            let point = touch.location(in: self.view)
            for(index, finger)in fingers.enumerated()
            {
                if finger == nil
                {
                    fingers[index] = String(format: "%p", touch)
                    paths[index]?.move(to: point)
                    fromPoints[index] = point
                    startPoints[index] = point
                    if(index == 0)
                    {
                        player1Points.append(point)
                    }
                    else
                    {
                        player2Points.append(point)
                    }
                    break
                }
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        for touch in touches{
            let point = touch.location(in: self.view)
            for(index,finger) in fingers.enumerated()
            {
                if let finger = finger , finger == String(format: "%p", touch){
                    if(index == 0 && player1Points.count > 1)
                    {
                        if !intersect(path: player1Points,newPoint: point,currentPoint: (paths[index]?.currentPoint)!)
                        {
                            fingers[index] = nil
                            lastPoints[index] = nil
                            self.layers[index]?.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0).cgColor
                            self.paths[index]?.removeAllPoints()
                            self.layers[index]?.removeFromSuperlayer()
                            self.player1Points.removeAll()
                            return
                        }
                    }
                    else if index == 1 && player2Points.count > 1
                    {
                        if !intersect(path: player2Points,newPoint: point,currentPoint: (paths[index]?.currentPoint)!)
                        {
                            fingers[index] = nil
                            lastPoints[index] = nil
                            self.layers[index]?.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0).cgColor
                            self.paths[index]?.removeAllPoints()
                            self.layers[index]?.removeFromSuperlayer()
                            self.player2Points.removeAll()
                            //self.touchesEnded(touches,with: event)
                            //self.player2Points.removeAll()
                            ///self.paths[index]?.removeAllPoints()
                            //self.layers[index]?.removeFromSuperlayer()
                            return
                        }
                    }
                    swiparoo[index] = true
                    paths[index]?.addLine(to: point)
                    layers[index]?.path = paths[index]?.cgPath
                    
                    self.view.layer.addSublayer(layers[index]!)
                    fromPoints[index] = point
                    if(index == 0)
                    {
                        player1Points.append(point)
                    }
                    else
                    {
                        player2Points.append(point)
                    }
                    break
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches{
            for(index,finger) in fingers.enumerated()
            {
                if let finger = finger , finger == String(format: "%p", touch)
                {
                    var tempLayer = CAShapeLayer()
                    var tempPath = UIBezierPath()
                    tempLayer.frame = (layers[index]?.frame)!
                    tempLayer.contents = layers[index]?.contents
                    tempPath.cgPath = (paths[index]?.cgPath)!
                    tempLayer.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5).cgColor
                    tempLayer.path = tempPath.cgPath
                    
                    self.view.layer.addSublayer(tempLayer)
                    self.paths[index]?.removeAllPoints()
                    self.layers[index]?.removeFromSuperlayer()
                    var tempBug = Bug()
                    var tempBugList = [Bug]()
                    for Bug in bugList
                    {
                        if(tempPath.contains(CGPoint(x:(Bug.posX),y:(Bug.posY))))
                        {
                            if(tempBug.team == 0)
                            {
                                tempBug.team = Bug.team
                                tempBugList.append(Bug)
                            }
                            else
                            {
                                if(Bug.team != tempBug.team)
                                {
                                    tempBugList.removeAll()
                                    break
                                }
                                else
                                {
                                    tempBugList.append(Bug)
                                }
                            }
                            //bugList = bugList.filter() { $0 !== Bug }
                        }
                    }
                    if(tempBugList.count > 1)
                    {
                        bugList = bugList.filter() { !tempBugList.contains($0)}
                        var newBigBug = Bug()
                        for Bug in tempBugList
                        {
                            newBigBug.posX += Bug.posX
                            newBigBug.posY += Bug.posY
                            newBigBug.bugWidth += Bug.bugWidth/2
                            newBigBug.bugHeight += Bug.bugHeight/2
                        }
                        newBigBug.posX = newBigBug.posX/CGFloat(tempBugList.count)
                        newBigBug.posY = newBigBug.posY/CGFloat(tempBugList.count)
                        if(tempBugList[0].team == 1)
                        {
                            team1Count -= tempBugList.count-1
                            newBigBug.imageView = UIImageView(image: team1Image)
                            newBigBug.team = 1
                            
                        }
                        else if(tempBugList[0].team == 2)
                        {
                            team2Count -= tempBugList.count-1
                            newBigBug.imageView = UIImageView(image: team2Image)
                            newBigBug.team = 2
                            
                        }
                        else if(tempBugList[0].team == 3)
                        {
                            newBigBug.imageView = UIImageView(image: bot1Image)
                            newBigBug.team = 3
                            
                        }
                        else if(tempBugList[0].team == 4)
                        {
                            newBigBug.imageView = UIImageView(image: bot2Image)
                            newBigBug.team = 4
                        }
                        else
                        {
                            newBigBug.imageView = UIImageView(image: bot3Image)
                            newBigBug.team = 5
                        }
                        
                        newBigBug.imageView?.frame = CGRect(x: newBigBug.posX, y: newBigBug.posY, width: newBigBug.bugWidth, height: newBigBug.bugHeight)
                        self.view.addSubview(newBigBug.imageView!)
                        bugList.append(newBigBug)
                    }
                    
                    if index == 0
                    {
                        player1Points.removeAll()
                    }
                    else
                    {
                        player2Points.removeAll()
                    }
                    
                    if(team1Count < 2)
                    {
                        submitScore.isHidden = false
                        submitScoreButton.isHidden = false
                        submitScoreText.isHidden = false
                        submitScoreLabel.isHidden = false
                        someoneWon = true
                        
                        submitScoreLabel.text = "Team Red WON!\nPlease enter your name below."
                    }
                    else if(team2Count < 2)
                    {
                        
                        submitScore.isHidden = false
                        submitScoreButton.isHidden = false
                        submitScoreText.isHidden = false
                        submitScoreLabel.isHidden = false
                        someoneWon = true
                        
                        submitScoreLabel.text = "Team Green WON!\nPlease enter your name below."
                        
                    }
                    
                    fingers[index] = nil
                    lastPoints[index] = nil
                    let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        tempLayer.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0).cgColor
                    }
                    
                }
            }
        }
    }
}
