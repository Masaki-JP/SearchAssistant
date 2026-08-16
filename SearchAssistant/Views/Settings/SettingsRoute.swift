enum SettingsRoute: Hashable {
    case searchButtonsBar
    case searchButtonsBarOrder
    case bookmarkList
    case bookmarkForm(Bookmark?)
    case bookmarkOrder([Bookmark])
}
