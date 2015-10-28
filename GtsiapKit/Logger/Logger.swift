// Copyright (c) 2015 Giorgos Tsiapaliokas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

public class Logger {
    // MARK: vars
    public let showFile: Bool
    public let showFunc: Bool
    public let showLine: Bool
    public let categories: [String]
    public static var globalCategories: [String]?

    init(showFile: Bool, showFunc: Bool, showLine: Bool, categories: [String]) {
        self.showFile = showFile
        self.showFunc = showFunc
        self.showLine = showLine
        self.categories = categories
    }

    public class func defaultLogger(categories: [String]) -> Logger{
        let logger = Logger(showFile: true, showFunc: true, showLine: true, categories: categories)
        return logger
    }

    // MARK: public func
    public func debug(msg: Any, file: String = __FILE__,
        funcString: String = __FUNCTION__, line: Int = __LINE__) {

        if Logger.globalCategories == nil {
            return
        }

        for it in categories {
            if (Logger.globalCategories!).contains(it) {
                let format = formatDebug(it, file: file, funcString: funcString, line: line)
                print("\(format)\(msg)")
                print("")
                return
            }
        }
    }

    // MARK: private func
    private func formatDebug(category: String, file: String, funcString: String, line: Int) -> String {
        return "(\(category))[\(NSString(string: file).pathComponents.last!):\(line)] \(funcString): "
    }

}
