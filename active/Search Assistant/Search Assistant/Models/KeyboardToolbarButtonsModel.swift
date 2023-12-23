import Foundation

struct KeyboardToolbarButtonsModel {
    var validButtons: Set<Platform> = [
        .google, .twitter, .instagram, .amazon, .youtube, .facebook, .mercari, .rakuma, .paypayFleaMarket
    ]
    
    mutating func validationToggle(platform: Platform) {
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
   
    init() {
        guard let decodedData = UserDefaults.standard.data(forKey: "keyboardToolbarButtons"),
              let keyboardToolbarButtons = try? JSONDecoder().decode(Set<Platform>.self, from: decodedData)
        else { return }
        self.validButtons = keyboardToolbarButtons
    }
}
