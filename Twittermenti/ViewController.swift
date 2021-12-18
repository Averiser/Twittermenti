//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON  

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
  
  let sentimentClassifier = TweetSentimentClassifier()
  
  let swifter = Swifter(consumerKey: "zUPScrl6hhnSuuGCb8f58SrFT", consumerSecret: "OcGxFQtrnPLxPF4d6xqn0KJnPLm403cLwHm1IxgSTjWcIILfsQ")
  

      override func viewDidLoad() {
          super.viewDidLoad()
        
        
        swifter.searchTweet(using: "#blessed", lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
          
          var tweets = [TweetSentimentClassifierInput]()
          
          for i in 0..<100 {
            if let tweet = results[i]["full_text"].string {
              let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
              tweets.append(tweetForClassification)
            }
          }
          print(tweets)
          
          do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            
            var sentimentScore = 0
            
            for pred in predictions {
              let sentiment = pred.label
              
              if sentiment == "Pos" {
                  sentimentScore += 1
              } else if sentiment == "Neg" {
                sentimentScore -= 1
              }
            }
            
            print(sentimentScore)
            
            
          } catch {
            print("There was an error making a prediction, \(error)")
          }
          
          
        }) { (error) in
          print("There was an error with the Twitter API Request, \(error)")
        }

          
      }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

