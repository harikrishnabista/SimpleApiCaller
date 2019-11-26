//
//  ViewController.swift
//  SimpleGenericApiCaller
//
//  Created by Hari Bista on 10/11/2019.
//  Copyright © 2019 bista. All rights reserved.
//

import UIKit

// MARK: - QuestionList
struct QuestionList: Codable {
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let query: String
    let answers: [Answer]
}

// MARK: - Answer
struct Answer: Codable {
    let correct: Bool
    let url: String
}


class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData(){
        if let url = URL(string: "https://gist.github.com/acrookston/e1af7bf2e2607db3d27a0b44ed1843c1/raw/490d746e54e774476652cf8ab65f9c912e54e95f/question.json") {
            ApiCaller<QuestionList>().callApi(url: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let questionList):
                        if let data = try? JSONEncoder().encode(questionList) {
                            let str = String(decoding: data, as: UTF8.self)
                            self.textView.text = str
                        }
                        print(questionList)
                    case .failure( _):
                        print("show error to user with user friendly message")
                    }
                }
            }
        }
    }
}

