import Foundation

struct KeyboardToolbarButtonsModel {
    private let userDefaultsKey = "keyboardToolbarButtons"
    var validButtons: Set<SASerchPlatform> = [
        .google, .twitter, .instagram, .amazon, .youtube, .facebook, .mercari, .rakuma, .paypayFleaMarket
    ]

    init() {
        guard let decodedData = UserDefaults.standard.data(forKey: userDefaultsKey),
              let keyboardToolbarButtons = try? JSONDecoder().decode(Set<SASerchPlatform>.self, from: decodedData)
        else { return }
        self.validButtons = keyboardToolbarButtons
    }

    mutating func validationToggle(_ platform: SASerchPlatform) {
        if validButtons.contains(platform) {
            validButtons.remove(platform)
        } else {
            validButtons.insert(platform)
        }
        save()
    }

    private func save() {
        guard let encodedData = try? JSONEncoder().encode(validButtons)
        else { return }
        UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
    }
}
