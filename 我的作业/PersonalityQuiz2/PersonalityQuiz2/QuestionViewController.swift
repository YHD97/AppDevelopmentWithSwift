import UIKit

class QuestionViewController: UIViewController {
    
//3.------------------------------------------------显示label button switch stack view
    @IBOutlet weak var questionLabel: UILabel!
    
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var singleButton1: UIButton!
    @IBOutlet weak var singleButton2: UIButton!
    @IBOutlet weak var singleButton3: UIButton!
    @IBOutlet weak var singleButton4: UIButton!
    
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var multiLabel1: UILabel!
    @IBOutlet weak var multiLabel2: UILabel!
    @IBOutlet weak var multiLabel3: UILabel!
    @IBOutlet weak var multiLabel4: UILabel!
    @IBOutlet weak var multiSwitch1: UISwitch!
    @IBOutlet weak var multiSwitch2: UISwitch!
    @IBOutlet weak var multiSwitch3: UISwitch!
    @IBOutlet weak var multiSwitch4: UISwitch!
    
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    
//2.------------------------------------------------定义问题内容，问题类型，答案选项
    var questions: [Question] = [
        Question(text: "Which food do you like the most?",
                 type:.single,
                 answers: [
                    Answer(text: "Steak", type:.dog),
                    Answer(text: "Fish", type:.cat),
                    Answer(text: "Carrot", type:.rabbit),
                    Answer(text: "Corn", type:.turtle)
            ]),
        Question(text: "Which activities do you enjoy?",
                 type:.multiple,
                 answers: [
                    Answer(text: "Swimming", type:.turtle),
                    Answer(text: "Sleeping", type:.cat),
                    Answer(text: "Cudding", type:.rabbit),
                    Answer(text: "Eating", type:.dog)
            ]),
        Question(text :"How much do you enjoy car rides?",
                 type:.ranged,
                 answers: [
                    Answer(text: "I dislike them", type:.cat),
                    Answer(text: "I get a little nervous", type:.rabbit),
                    Answer(text: "I barely notice them", type:.turtle),
                    Answer(text: "I love them", type:.dog)
            ])
    ]
    
    
    var questionIndex = 0 //问题进度
    var answersChosen: [Answer] = [] //选择答案数组

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
//4.------------------------------------------------更新问问题的界面，3种
    func updateUI() {
//        先隐藏所有的问题和答案选项
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
//        从第一个问题开始传递数据
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex)/Float(questions.count)
        
//        导航栏部标题
        navigationItem.title = "Question #\(questionIndex+1)"
//        问题
        questionLabel.text = currentQuestion.text
//        底部进程显示
        questionProgressView.setProgress(totalProgress, animated: true)
        
//        选择要显示的问题和答案选项画面
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswers)
        case.multiple:
            updateMultipleStack(using: currentAnswers)
        case.ranged:
            updateRangedStack(using: currentAnswers)
        }
    }

    
    func updateSingleStack(using answers: [Answer] ) {
//        显示单选问题，显示单选选项按钮内容
        singleStackView.isHidden = false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    func updateMultipleStack(using answers: [Answer]) {
//        显示多选问题和多项答案选项内容，初始化switch为关闭off
        multipleStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        multiLabel1.text = answers[0].text
        multiLabel2.text = answers[1].text
        multiLabel3.text = answers[2].text
        multiLabel4.text = answers[3].text
    }
    
    func updateRangedStack(using answers: [Answer]) {
//        显示范围问题和答案第一个和最后一个选项内容
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
   
    
//5.------------------------------------------------取走回答 选择的值 answers
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
//        把选择的选项的内容和类型叠加到答案选择数组里
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswers[0])
        case singleButton2:
            answersChosen.append(currentAnswers[1])
        case singleButton3:
            answersChosen.append(currentAnswers[2])
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        default:
            break
        }
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed(_ sender: Any) {
        let currenAnswers = questions[questionIndex].answers
        
        if multiSwitch1.isOn {
            answersChosen.append(currenAnswers[0])
        }
        if multiSwitch2.isOn {
            answersChosen.append(currenAnswers[1])
        }
        if multiSwitch3.isOn {
            answersChosen.append(currenAnswers[2])
        }
        if multiSwitch4.isOn {
            answersChosen.append(currenAnswers[3])
        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    
//6.------------------------------------------------每一次提交答案选项后，检查继续更新问题还是转场到结果视图
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "ResultsSegue", sender: nil)
        }
    }
//    如果转场标识符正确，就转到结果视图
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ResultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.responses = answersChosen
        }
    }

}
