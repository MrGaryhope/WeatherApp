# WeatherApp
## A weather app based on OpenWeatherAPI


To make it work for yourself, register on OpenWeather, and get yourself your **own API key**. After that, put your API key in the API variable.

Also, I made some changes to the day converter, to print out days in Russian. To remove that and have it in English, remove this code

```
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
```

in WeatherTableViewCell
