//
//  ViewController.swift
//  TicTacToe
//
//  Created by RevNex on 13.03.18.
//  Copyright © 2018 MP GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let model = TicTacToeModel()
    
    @IBOutlet weak var resp: UILabel!
    @IBOutlet weak var ticTacToeView: TicTacToeView!
    
    enum Player : String {
        case X = "X"
        case O = "O"
    }
    
    /* Structs used for communication with nodeJS REST API */
    struct fieldStatus: Decodable {
        var fieldStatus = [[String]](repeating: [String](repeating: "", count: 3), count: 3)
    }
    
    struct action: Decodable, Encodable {
        var playerId: Int
        var x: Int
        var y: Int
    }
    /* ====================================================*/
    
    @IBAction func getFieldStatusFromRest(_ sender: Any) {
        //Implementing URLSession
        let urlString = "http://localhost:3000/"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            guard let board = try? JSONDecoder().decode(fieldStatus.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            
            print("\(board.fieldStatus)")
            self.model.fieldStatus = board.fieldStatus;
            
            DispatchQueue.main.async {
                self.ticTacToeView.setNeedsDisplay();
            }
        
        }.resume()
    }
        
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let touchPosX: CGFloat = sender.location(in: ticTacToeView).x
        let touchPosY: CGFloat = sender.location(in: ticTacToeView).y
        
        let cellWidth: CGFloat = ticTacToeView.bounds.width / 3
        
        let row = Int(touchPosX / cellWidth)
        let col = Int(touchPosY / cellWidth)
        
        var myPlayerId: Int = -1;
        
        if (self.model.currPlayer == "X") {
            myPlayerId = 0
        } else if (self.model.currPlayer == "O") {
            myPlayerId = 1
        }
        
        let myAction = action(playerId: myPlayerId, x: row, y: col);
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://localhost:3000/action")! as URL)
        request.httpMethod = "POST"
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(myAction)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            print("ERROR")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            } else {
                print("response = \(response)")
                print("data = \(data)")
                
                let myResponse = String(data: data!, encoding: String.Encoding.utf8);
                
                DispatchQueue.main.async {
                    self.resp.text = myResponse
                }
            
            }
    
        }
        task.resume()
        
        //if field is empty, symbol is drawn and player switched
        if(model.fieldStatus[row][col] == "" && sender.isEnabled) {
            model.fieldStatus[row][col] = model.currPlayer
            
            if(!checkWinner()) {
                
                switch model.currPlayer {
                    case Player.X.rawValue :
                        model.currPlayer = Player.O.rawValue
                        break;
                    case Player.O.rawValue :
                        model.currPlayer = Player.X.rawValue
                        break;
                    default:
                        break;
                }
            } else {
                sender.isEnabled = false
            }
        }
        
        print(sender.location(in: ticTacToeView));
        ticTacToeView.setNeedsDisplay()
    }
    
    /* checkWinner() also implemented server-side */
    func checkWinner() -> Bool {
        var winnerFound: Bool = false
        var counter = 0
        
        //check horizontal
        for i in 0...2 {
            for j in 0...2 {
                if(model.fieldStatus[i][j] != model.currPlayer) {
                    counter = 0
                    break;
                } else {
                    counter += 1
                }
            }
            if(counter == 3) {
                winnerFound = true;
                break;
            }
        }
        
        //check vertical
        for i in 0...2 {
            for j in 0...2 {
                if(model.fieldStatus[j][i] != model.currPlayer) {
                    counter = 0
                    break;
                } else {
                    counter += 1
                }
            }
            if(counter == 3) {
                winnerFound = true;
                break;
            }
        }
        
        //check diagonal top-left to bottom-right
        for i in 0...2 {
            if(model.fieldStatus[i][i] != model.currPlayer) {
                counter = 0
                break;
            } else {
                counter += 1
            }
            if(counter == 3) {
                winnerFound = true;
                break;
            }
        }
        /*
        let ri = 0...2
        let rj = reverse(0...2)
        
        //check diagonal bottom-left to top-right
        for (i,j) in zip(ri, rj) {
            if(TicTacToeView.fieldStatus[i][j] != currPlayer) {
                break;
            } else {
                counter += 1
            }
            if(counter == 3) {
                winnerFound = true;
                break;
            }
        }*/
        
        if(winnerFound) {
            print("\(model.currPlayer) has won!")
        }
        
        return winnerFound
    }
    
    
    private func executeRepeatedly() {
        self.getFieldStatusFromRest(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.executeRepeatedly()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticTacToeView.model = self.model

        model.currPlayer = Player.X.rawValue
        
        self.executeRepeatedly()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

