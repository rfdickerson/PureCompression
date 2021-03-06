//
//  Trie.swift
//  PureDeflate
//
//  Created by Robert Dickerson on 4/30/16.
//
//

import Foundation

class TrieNode {
    
    var children = [TrieNode]()
    
    var final: Bool = false
    
    var value: Byte?
    
    var indices = [Int]()
    
    
}

extension TrieNode {
    
    func insert(bytes: [Byte], index: Int) {
     
        var currentNode = self
        
        for byte in bytes {
            
            // search for child if not exists, then add it 
            var found = false
            
            for child in currentNode.children {
                
                if child.value == byte {
                    
                    currentNode = child
                    found = true
                    
                } else {
                    
                    
                }
            }
            
            if !found {
                
                let newNode = TrieNode()
                newNode.value = byte
                currentNode.children.append( newNode )
                
                currentNode = newNode

            }

            
        }
        
        currentNode.indices.append(index)
        currentNode.final = true
        
        
        
    }
    
    func contains(bytes: [Byte]) -> [Int] {
        
        var currentNode = self
        
        for byte in bytes {
            
            for child in currentNode.children {
                
                if child.value == byte {
                    
                    currentNode = child
                    
                } else {
                    
                    // return false
                }
                
            }
            
        }
        
        if currentNode.final == true {
             return currentNode.indices
        } else {
            return []
        }
        
       
    }
}