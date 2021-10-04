//
//  WeatherTableViewCell.swift
//  weatherApp
//
//  Created by Егор Максимов on 17.08.2021.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
 
    func configure(with model: Daily) {
        self.lowTempLabel.text = "\(Int(model.temp.min))°"
        self.highTempLabel.text = "\(Int(model.temp.max))°"
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textAlignment = .center
        
        let dayTranslated = getDayForDate(Date(timeIntervalSince1970: Double(model.dt)))
        
        if (dayTranslated.localizedStandardContains("Monday")) {
            self.dayLabel.text = "Понедельник"
        } else if (dayTranslated.localizedStandardContains("Tuesday")) {
            self.dayLabel.text = "Вторник"
        } else if (dayTranslated.localizedStandardContains("Wednesday")) {
            self.dayLabel.text = "Среда"
        } else if (dayTranslated.localizedStandardContains("Thursday")) {
            self.dayLabel.text = "Четверг"
        } else if (dayTranslated.localizedStandardContains("Friday")) {
            self.dayLabel.text = "Пятница"
        } else if (dayTranslated.localizedStandardContains("Saturday")) {
            self.dayLabel.text = "Суббота"
        } else if (dayTranslated.localizedStandardContains("Sunday")) {
            self.dayLabel.text = "Воскресенье"
        }
        
        self.iconImageView.image = UIImage(named: "icRain")
        self.iconImageView.contentMode = .scaleAspectFit
        
        let decidedIcon = model.weather.map { ($0 ).icon }
        
        if (decidedIcon.contains(Icon.the01D)) {
            self.iconImageView.image = UIImage(named: "icClear")
        } else if (decidedIcon.contains(Icon.the01N)) {
            self.iconImageView.image = UIImage(named: "icClear")
        } else if (decidedIcon.contains(Icon.the02D)) {
            self.iconImageView.image = UIImage(named: "icCloudy")
        } else if (decidedIcon.contains(Icon.the02N)) {
            self.iconImageView.image = UIImage(named: "icCloudy")
        } else if (decidedIcon.contains(Icon.the03D)) {
            self.iconImageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the03N)) {
            self.iconImageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the04N)) {
            self.iconImageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the04D)) {
            self.iconImageView.image = UIImage(named: "icCloud")
        } else if (decidedIcon.contains(Icon.the10N)) {
            self.iconImageView.image = UIImage(named: "icRain")
        } else if (decidedIcon.contains(Icon.the10D)) {
            self.iconImageView.image = UIImage(named: "icRain")
        }
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "rus")
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: inputDate)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
