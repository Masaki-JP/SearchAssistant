func reportError(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line,
    _ error: Error
) {
    print("💥💥💥")
    print("fileID: \(fileID)")
    print("function: \(function)")
    print("line: \(line)")
    print("error: \(error) (\(type(of: error)))")
    print("💥💥💥")
}

func reportMockAction(
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
) {
    print("")
    print("Called MockAction")
    print("function: \(function)")
    print("line: \(line)")
    print("fileID: \(fileID)")
    print("")
}
