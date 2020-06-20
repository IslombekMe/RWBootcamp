//
//  ViewController.swift
//  CompatibilitySlider-Start
//
//  Created by Jay Strawn on 6/16/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import UIKit

enum ButtonState: String {
    case start = "Let's start"
    case nextItem = "Next item"
    case nextPerson = "Switch to Person 2"
    case finish = "Calculate Compatibility"
}

class ViewController: UIViewController {

    @IBOutlet weak var compatibilityItemLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!

    var compatibilityItems = ["Cats 😺", "Dogs 🐶", "Space 🌌", "Pikachu", "RW :]"] // Add more!
    var currentItemIndex: Int = 0 {
        didSet {
            if currentItemIndex == compatibilityItems.count - 1 {
                setButtonTitle(to: currentPerson == person1 ? .nextPerson : .finish)
            }

            if currentItemIndex > compatibilityItems.count - 1 {
                print("Hold your horses! You're going out of range...")
                currentItemIndex = oldValue
                return
            }
        }
    }

    var person1 = Person(id: 1, items: [:])
    var person2 = Person(id: 2, items: [:])
    var currentPerson: Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print(sender.value)
    }

    @IBAction func didPressActionButton(_ sender: UIButton) {
        switch sender.title(for: .normal) {
        case ButtonState.start.rawValue:
            questionLabel.isHidden = false
            slider.isHidden = false
            setCurrentPerson(to: person1)
            
        case ButtonState.nextItem.rawValue:
            let currentItem = compatibilityItems[currentItemIndex]
            currentPerson?.items.updateValue(slider.value, forKey: currentItem)
            currentItemIndex += 1
            showComparisonItem()

        case ButtonState.nextPerson.rawValue:
            setCurrentPerson(to: person2)

        case ButtonState.finish.rawValue:
            finishComparison()

        default:
            print("Oops, what should we do now 🤔?")
            break
        }

    }

    func reset() {
        currentPerson = nil
        questionLabel.isHidden = true
        slider.isHidden = true
        setButtonTitle(to: .start)
        person1.items = [:]
        person2.items = [:]
        compatibilityItemLabel.text = "PikaMate"
    }

    func finishComparison() {
        let alert = UIAlertController(title: "Results", message: "You two are \(calculateCompatibility()) compatible", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true) {
            self.reset()
        }
    }

    func calculateCompatibility() -> String {
        // If diff 0.0 is 100% and 5.0 is 0%, calculate match percentage
        var percentagesForAllItems: [Double] = []

        for (key, person1Rating) in person1.items {
            let person2Rating = person2.items[key] ?? 0
            let difference = abs(person1Rating - person2Rating) / 5.0
            percentagesForAllItems.append(Double(difference))
        }

        let sumOfAllPercentages = percentagesForAllItems.reduce(0, +)
        let matchPercentage = sumOfAllPercentages / Double(compatibilityItems.count)
        print(matchPercentage, "%")
        let matchString = 100 - (matchPercentage * 100).rounded()
        return "\(matchString)%"
    }

}

// changes UI State
extension ViewController {
    func setCurrentPerson(to person: Person) {
        currentItemIndex = 0
        currentPerson = person
        questionLabel.text = "Person \(currentPerson!.id), how do you feel about..."
        showComparisonItem()
        setButtonTitle(to: .nextItem)
    }

    func showComparisonItem() {
        compatibilityItemLabel.text = compatibilityItems[currentItemIndex]
    }

    func setButtonTitle(to state: ButtonState) {
        actionButton.setTitle(state.rawValue, for: .normal)
    }

}
