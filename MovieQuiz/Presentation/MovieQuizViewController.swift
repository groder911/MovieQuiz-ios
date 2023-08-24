

import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    private var presenter: MovieQuizPresenter!
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        yesButton.layer.cornerRadius = 15
        noButton.layer.cornerRadius = 15
        
        
        presenter = MovieQuizPresenter(viewController: self)
        
        self.imageView.layer.cornerRadius = 20
        
        setNeedsStatusBarAppearanceUpdate()
        
    }

    func show(quiz step: QuizStepViewModel) {
        
        self.counterLabel.text = step.questionNumber
        self.imageView.image = step.image
        self.textLabel.text = step.question
        self.yesButton.isEnabled = true
        self.noButton.isEnabled = true
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor(named: "YP Green")?.cgColor : UIColor(named: "YP Red")?.cgColor
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func hideImageBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let action: (() -> Void) = { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз",
            completion: action)
        
        let alertPresenter = AlertPresenter(controller: self, model: alertModel)
        alertPresenter.run()
    }
    
    // MARK: - IBAction
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        
    }
}

   
