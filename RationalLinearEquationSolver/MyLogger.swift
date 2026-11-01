//
//  MyLogger.swift
//  SimplePsViewer
//
//  To use with mac version 10.13 define -DV1013 as other
//  Changed by LegoEsprit 2026-01-06 Some spellings corrected
//  Changed by LegoEsprit 2025-08-20 Logger message changed a bit, as method was not displayed anymore
//  Changed by LegoEsprit 2024-01-27 Message abbreviation added
//  Created by LegoEsprit 2023-05-06
//
//                        , file: URL = URL(filePath: #file) -> MyLogger !!!
/*
> Examples on how to retrieve the log info from "Console" log files:
 
sudo log stream --predicate 'subsystem == <Bundle Identifier>'
sudo log stream --predicate 'subsystem == <Bundle Identifier>' | awk '{print $0}'
sudo log show --predicate 'subsystem == <Bundle Identifier>' --last 1h
sudo log show --predicate 'subsystem == <Bundle Identifier>' --last 1h | awk 'NR>2 {print substr($0,12,15) " T:" substr($0,index($0,"00 ")+3, 8)  substr($0, index($0,"]")+1) }'
sudo log stream --predicate 'subsystem == <Bundle Identifier>' | awk 'NR>2 {print substr($0,12,15) " T:" substr($0,index($0,"00 ")+3, 8)  substr($0, index($0,"]")+1) }'
*/


import Foundation

/// To support macOS 10.13 we define here some dummy classes and methods.
/// :configuration = Debug
/// OTHER_SWIFT_FLAGS[arch=*] = -DSIMULATE_off -DV1013
/// :configuration = Release
/// OTHER_SWIFT_FLAGS[arch=*] = -DV1013
/// :completeSettings = some
/// OTHER_SWIFT_FLAGS
///
/// May be using NSLog() this can be enhanced!
///


#if V1013
    struct OSLogPrivacy {
        var `public`: Int
    }
    enum OSLogType {
        case `default`
    }

    class Logger {
        enum Levels {
            case `public`
        }
        init(subsystem: String, category: String) {}
        class func login(_ any: String) {}
        class func logout(_ any: String) {}
        func log(level: Any, _ text: Any) {}
    }
 
#else
    import os.log
#endif

func login(_ message: String
           , level: OSLogType = OSLogType.default
           , className: String = ""
           , file: String = #file
           , function: StaticString = #function
) {
    if #available(macOS 11.0, *) {
        Logger.login(message, level: level, className: className, file: file, function: function)
    } else {
        // Fallback on earlier versions
    }
}

func logout(_ message: String
            , level: OSLogType = OSLogType.default
            , className: String = ""
            , file: String = #file
            , function: StaticString = #function
) {
    if #available(macOS 11.0, *) {
        Logger.logout(message, level: level, className: className, file: file, function: function)
    } else {
        // Fallback on earlier versions
    }
}

func logWrite(_ message: String
              , level: OSLogType = OSLogType.default
              , className: String = ""
              , file: String = #file
              , function: StaticString = #function
) {
    if #available(macOS 11.0, *) {
        Logger.write(message, level: level, className: className, file: file, function: function)
    } else {
        // Fallback on earlier versions
    }
}




/// How to use
///
///         Logger.login("In-Message"[, className: className])                  // Increases indent
///         ...
///         Logger.logout("Out-Message"[, className: className])                // Decreases indent
///
///         Logger.write("Write-Message"[, className: className])               // write message
///  usage of [, className: className] is optional, but recommended to extract
///  the class (I could not identify a method to retrieve the class name by
///  other means). By the way "className" is only available for instances
///  derived from NSObject. Otherwise an arbitrary string might be entered
///  instead.
///
///  Comments:
///  =========
///  Contrary to Apple's intend I am using "privacy: .public", as otherwise
///  you will only get useless log files filled with <private> like:
///
/// ╭╴ ViewController.saveAndConvert(_:), <private>
/// | <private>PsEditView.saveFileToPsUrl(), <private>
/// | <private>PsEditView.saveFileToPsUrl(), <private>
/// | <private>PsEditView.saveFileToPsUrl(), <private>
/// | ╭╴ PsEditView|saveFileTo(path:), <private>
/// | ╰╴ PsEditView|saveFileTo(path:), <private>
/// | ╭╴ ViewController.convertPsToPdf(), <private>
/// | | <private>Shell.init(_:arguments:), <private>
/// | ╰╴ ViewController.convertPsToPdf(), <private>
/// ╰╴ ViewController.saveAndConvert(_:), <private>
///
///  It is even not possible to control the privacy setting via a parameter. Therefore please
///  don't use this Logger for security sensitive information. (See  "OSLogPrivacy.public")
///
///
///#if DEBUG
///Logger.write("I'm running in DEBUG mode")
///#else
///Logger.write("I'm not running in DEBUG mode")
///#endif


extension String {
    /*
	/// Avoids the conversion to URL.
	/// - Returns: Extension (all characters after dot) from string self as Substring
	var lastComponent: Substring {
		guard let lastIndex = lastIndex(of: ".") else {
			return self[...]
		}
		let pointIndex = index(after: lastIndex)
		return self[pointIndex...]
	}
     */
	
		
	func abbreviate(limitCount: Int, prefix minCount: Int = 5) -> String {
		if count > limitCount + 1 {
			var begin = startIndex
			let _ = formIndex(&begin
							, offsetBy: max(0, count-limitCount+minCount)
							, limitedBy: endIndex
					   )
			return prefix(minCount)+"…"+self[begin..<endIndex]
		}
		else {
			return self
		}
	}

}



@available(macOS, introduced: 11)
/// Logger extension!
extension Logger {
    
    private static let subsystem = Bundle.main.bundleIdentifier!
    private static var fill: String = ""                                        // This should be thread save as we change it only on main thread
    // See. if Thread.isMainThread... below
    
    private static let startStamp_s = Date.timeIntervalSinceReferenceDate
    /// Sonoma Xcode suppresses timestamp (might be shown on preceding line). Therefore we add a
    /// timestamp manually
    static var elapsed: String {
        get {
            return String(format: "%10.3f"
                          , Date.timeIntervalSinceReferenceDate - startStamp_s
            )
        }
    }
    
    
    
    private static let main = Logger(subsystem: subsystem, category: "")
    /*
     static let debugLevel = OSLogType.debug                                    // This will not be added to Console log unless configuration has been changed
     
     debug: OSLogType
     info: OSLogType
     default: OSLogType -> notice
     error: OSLogType
     fault: OSLogType
     */
    
    static let debugLevel = OSLogType.default
    
    public static var debug = main
    
    
    /// Generates a name from either classname or file name
    /// - Parameters:
    ///   - className: className or empty string
    ///   - file: filename of the sender
    /// - Returns: if classname is given return "<class>." otherwise "<filename>|"
    private static func name(  className: String
                               , file: String
    ) -> String {
        if className.isEmpty {
            // extracting the filename part only. Unfortunately we can't use
            // let replacement = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
            let lastComponent = file.split(separator: "/").last!
            return "\(lastComponent.split(separator: ".").first!),"
        }
        else {
            // as the app name is redundant we only use the last part
            return "\(className.components(separatedBy: ".").last ?? className)."
        }
    }
    
    /// Removes <cr>'s from string and abbreviates the text to fit into a single line
    /// - Parameter message: Text message of the log.
    private static func shortMessage(_ message: String) -> String {
        let cr = "\n"
        return message.replacingOccurrences(of: cr, with: "").abbreviate(limitCount: 80)
    }
    
#if V1013
#else
    /// Writes log message to console file
    /// - Parameters:
    ///   - className: The retrieved class name
    ///   - file: Alternatively the file name
    ///   - thread: Either "T" for dispatched thread, blank or plus/minus indent
    ///   - function: Name of the calling function
    ///   - message: The debug message
    fileprivate static func privateLog(  level: OSLogType = debugLevel
                                         , className: String
                                         , file: String
                                         , thread: String
                                         , function: StaticString
                                         , _ message: String
    ) {
        let name = name(className: className, file: file)
        
#if DEBUG
        let myLevel = OSLogType.default
#else
        let myLevel = level
#endif
        Logger.main.log(level: myLevel,
                        //  v--- must be all at same column!
                        """
                        \(elapsed):\
                        \(fill, privacy: OSLogPrivacy.public)\
                        \(thread, privacy: OSLogPrivacy.public)\
                        \(name, privacy: OSLogPrivacy.public)\
                        \(function, privacy: OSLogPrivacy.public) \
                        \(shortMessage(message), privacy: OSLogPrivacy.public)
                        """
                        //  ^--- must be all at same column!
        )
        
    }
#endif
    
    /// Writes message to log file keeping the level
    /// - Parameters:
    ///   - message: Message to be written to console
    ///   - level: Optional level default to 'notice'
    ///   - className: Optional classname if given this name is added in front of function
    ///   - file: Optional filename used for the name if no filename is given - defaults to #file
    ///   - function: Optional method name - defaults to #function
    ///   - line: Optional line number - defaults to #line
    static func write(_ message: String
                      , level: OSLogType = debugLevel
                      , className: String = ""
                      , file: String = #file
                      , function: StaticString = #function
                      //, line: UInt = #line
    ) {
        
        let thread = Thread.isMainThread ? " " : "T->"
#if V1013
#else
        privateLog(level: level
                   , className: className
                   , file: file
                   , thread: thread
                   , function: function
                   , shortMessage(message)
        )
#endif
    }
    
    
    /// Increases the log level indent
    /// - Parameters:
    ///   see write
    static func login(_ message: String
                      , level: OSLogType = debugLevel
                      , className: String = ""
                      , file: String = #file
                      , function: StaticString = #function
                      //, line: UInt = #line
    ) {
        let thread = Thread.isMainThread ? "╭╴" : "T->"
#if V1013
#else
        privateLog(level: level
                   , className: className
                   , file: file
                   , thread: thread
                   , function: function
                   , shortMessage(message)
        )
#endif
        if Thread.isMainThread {
            fill += "│ "
        }
    }
    
    
    /// Decreases the log level indent
    /// - Parameters:
    ///   see write
    static func logout(_ message: String
                       , level: OSLogType = debugLevel
                       , className: String = ""
                       , file: String = #file
                       , function: StaticString = #function
                       //, line: UInt = #line
    ) {
        if Thread.isMainThread {
            if fill.count >= 2 {
                fill.removeLast(2)
            }
        }
        let thread = Thread.isMainThread ? "╰╴" : "T"
#if V1013
#else
        privateLog(  level: level
                   , className: className
                   , file: file
                   , thread: thread
                   , function: function
                   , shortMessage(message)
        )
#endif
    }
    
}

