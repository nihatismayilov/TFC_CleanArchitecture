//
//  ConsoleLogHandler.swift
//  data
//
//  Created by Nihad Ismayilov on 22.07.24.
//

import Foundation

class ConsoleLogHandler: LogHandler {
    func log(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
