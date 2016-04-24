import XCTest

import Foundation

@testable import Deflate

class TestDeflate : XCTestCase {
    
    static var allTests: [(String, TestDeflate -> () throws -> Void)] {
        return [
                   ("testDeflate", testDeflate),
                   ("testFindLongestSubstring", testFindLongestSubstring),
                   ("testDeflateOnBook", testDeflateOnBook)
        ]
    }
    
    func testDeflate() {
        
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x40]
        
        let output = deflate(buffer: input)
        
        var correct = [Output]()
        correct.append( .value(0x80) )
        correct.append( .reference(Reference(length: 3, distance: 1)))
        correct.append( .value(0x40))
        
        XCTAssertEqual(output.count, correct.count)
        
        for i in 0...output.count-1 {
            XCTAssertEqual(output[i], correct[i])
        }
        print (output)
        //
        
    }
    
    func testDeflateOnBook() {
        let data = NSData(contentsOfFile: "/Users/Robert/swift-at-ibm/gzip-compression/data/simple.txt")
        
        var bytes = [Byte](repeating: 0x00, count: data!.length)
        
        data?.getBytes(&bytes, length: (data?.length)!)
        
        let output = deflate(buffer: bytes)
        
        let stream = serialize(output: output)
        
        let compressionRatio = Double(stream.count)/Double(bytes.count)
        
        print("Compression ratio \(compressionRatio)")
        
    }
    
    func testSerialize() {
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80, 0x40]
        let output = deflate(buffer: input)
        let serializedOutput = serialize(output: output)
        
        print(serializedOutput)
    }
    
    func testDeflate2() {
        
        let input: [Byte] = [0x80, 0x80, 0x40, 0x80, 0x80]
        
        let output = deflate(buffer: input)
        
        var correct = [Output]()
        correct.append( .value(0x80))
        correct.append( .value(0x80))
        correct.append( .value(0x40))
        correct.append( .reference(Reference(length: 2, distance: 3)))
        correct.append( .value(0x40))
        
        XCTAssertEqual(output.count, correct.count)
        
       
        print (output)
        //
        
    }

    
    /**
    * Should return a reference (1, 4)
    *
    */
    func testFindLongestSubstring() {
        let input: [Byte] = [0x80, 0x80, 0x80, 0x80]
        
        let reference = findLongestSubstring(index: 1, buffer: input)
        
        XCTAssertNotNil(reference)
        
        let correct = Reference(length: 3, distance: 1)
        XCTAssertEqual(reference, correct)
        
        print(reference)
    }
    
    /**
     * Should return a reference (1, 4)
     *
     */
    func testFindLongestSubstring2() {
        let input: [Byte] = [0x80, 0x40, 0x20, 0x80, 0x40, 0x20]
        
        let reference = findLongestSubstring(index: 3, buffer: input)
        
        XCTAssertNotNil(reference)
        
        let correct = Reference(length: 3, distance: 3)
        
        XCTAssertEqual(reference, correct)
        
        print(reference)
    }
    
    func testFindLongestSubstring3() {
        let input: [Byte] = [0x80, 0x40, 0x20, 0x80, 0x40, 0x20]
        
        let reference = findLongestSubstring(index: 2, buffer: input)
        
        XCTAssertNil(reference)
        
    }
    
    func testFindLongestSubstring4() {
        
        let input: [Byte] = [0x01, 0x02, 0x03, 0x04, 0x02, 0x03, 0x04]
        
        let reference = findLongestSubstring(index: 4, buffer: input)
        
        XCTAssertNotNil(reference)
        
        let correct = Reference(length: 3, distance: 3)
        
        XCTAssertEqual(reference, correct)
        
        print(reference)
    }
}