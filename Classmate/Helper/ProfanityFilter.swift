
//
//  ProfanityFilter.swift
//
// Copyright 2017 Adrian Bolinger
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify,
// merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be included in all copies
// or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//
//  Modified by Raheel Shah on 4/19/18.
//

import Foundation
class ProfanityFilter: NSObject {
    
    static let sharedInstance = ProfanityFilter()
    private override init() {}
    
    
    private let dirtyWords = RCValues.sharedInstance.string(forKey: .profanityText)
    
    private func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex expression: \(error.localizedDescription)")
            return []
        }
    }
    
    public func removeAbuses(_ string: String) -> String {
        let dirtyWords = matches(for: self.dirtyWords, in: string)
        
        if dirtyWords.count == 0 {
            return string
        } else {
            var newString = string
            
            dirtyWords.forEach({ dirtyWord in
                let newWord = String(repeating: "😲", count: dirtyWord.characters.count)
                newString = newString.replacingOccurrences(of: dirtyWord, with: newWord, options: [.caseInsensitive])
            })
            
            return newString
        }
    }
}
