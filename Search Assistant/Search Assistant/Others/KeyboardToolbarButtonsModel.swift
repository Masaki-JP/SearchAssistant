import Foundation

struct KeyboardToolbarButtonsModel {
    var validButtons: Set<SASerchPlatform> = [
        .google, .twitter, .instagram, .amazon, .youtube, .facebook, .mercari, .rakuma, .paypayFleaMarket
    ]

    init() {
        guard let decodedData = UserDefaults.standard.data(forKey: "keyboardToolbarButtons"),
              let keyboardToolbarButtons = try? JSONDecoder().decode(Set<SASerchPlatform>.self, from: decodedData)
        else { return }
        self.validButtons = keyboardToolbarButtons
    }

    mutating func validationToggle(platform: SASerchPlatform) {
        if validButtons.contains(platform) {
            validButtons.remove(platform)
        } else {
            validButtons.insert(platform)
        }
        updateUserDefaults()
    }
    private func updateUserDefaults() {
        let encodedData = try! JSONEncoder().encode(validButtons)
        UserDefaults.standard.set(encodedData, forKey: "keyboardToolbarButtons")
    }
}
