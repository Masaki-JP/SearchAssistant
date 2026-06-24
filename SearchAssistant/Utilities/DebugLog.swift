import Foundation
import OSLog

private enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "SearchAssistant"
    
    static let action = Logger(subsystem: subsystem, category: "Action")
    static let error = Logger(subsystem: subsystem, category: "Error")
}

func reportError(
    _ error: any Error,
    message: String = "",
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
) {
#if DEBUG
    let errorDescription = String(describing: error)
    let errorType = String(describing: type(of: error))
    
    AppLog.error.error(
        "message=\(message, privacy: .public) error=\(errorDescription, privacy: .private) type=\(errorType, privacy: .public) fileID=\(fileID, privacy: .public) function=\(function, privacy: .public) line=\(line)"
    )
#endif
}

func reportAction(
    message: String = "",
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
) {
#if DEBUG
    AppLog.action.debug(
        "action message=\(message, privacy: .public) fileID=\(fileID, privacy: .public) function=\(function, privacy: .public) line=\(line)"
    )
#endif
}
