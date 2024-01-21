import Foundation

#warning("削除の際はUserDefaultsのキーを以前使用していたキーとしてメモしておく")
struct KeyboardToolbarButtonsModel {
    private let userDefaultsKey = "keyboardToolbarButtons"
    private(set) var validButtons = Set(SASerchPlatform.allCases)

    init() {
        guard let decodedData = UserDefaults.standard.data(forKey: userDefaultsKey),
              let validButtons = try? JSONDecoder().decode(Set<SASerchPlatform>.self, from: decodedData)
        else { return }
        self.validButtons = validButtons
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
