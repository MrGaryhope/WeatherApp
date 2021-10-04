//
//  WeatherCollectionViewCell.swift
//  weatherApp
//
//  Created by Егор Максимов on 28.09.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WeatherCollectionViewCell"
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    
    func configure (with model: Current) {
        self.tempLabel.text = "\(Int(model.temp))°"
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
        
        self.hourLabel.text = "\(getDayForDate(Date(timeIntervalSince1970: Double(model.dt))))"
    }
    
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: inputDate)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
    }
}
