//
//  WolframRules.swift
//  GO-Life
//
//  Created by Elliot Rapp on 8/27/24.
//

import Foundation
import SwiftUI
import Combine

enum WolframCellState {
    case alive
    case dead
}



class WolframModel: ObservableObject {
    static let shared = WolframModel()
    
    @Published var rows = 100
    @Published var columns = 50
    @Published var grid: [[WolframCellState]] = Array(repeating: Array(repeating: .dead, count: 27), count: 50)
    @Published var resourceMap: [[Double]] = Array(repeating: Array(repeating: 0.5, count: 27), count: 50)
    @Published var timer: AnyCancellable? = nil
    
    init() {
        // Initialize grid and resourceMap
        grid = Array(repeating: Array(repeating: .dead, count: columns), count: rows)
        resourceMap = Array(repeating: Array(repeating: 0.5, count: columns), count: rows)
        
        // Set up an initial pattern for the first row
        if rows > 0 && columns > 0 {
            grid[0][columns / 2] = .alive
            // Optional: Add more alive cells to initialize the first row with a pattern
        }
    }
    
    func startSimulation() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            self?.generate()
        }
    }
    
    func stopSimulation() {
        timer?.cancel()
        timer = nil
    }
    
    func generate() {
        // Create a new generation array initialized with dead cells
        var nextgen = Array(repeating: WolframCellState.dead, count: columns)
        
        // Loop through each cell, excluding the first and last to avoid out-of-bounds errors
        for i in 1..<columns - 1 {
            let left = grid[0][i - 1]    // Left neighbor state
            let me = grid[0][i]          // Current state
            let right = grid[0][i + 1]   // Right neighbor state
            
            // Compute next state based on the rule and assign it to the next generation
            nextgen[i] = rule110(left: left, center: me, right: right)
        }
        
        // Shift the current grid down by one row
        for row in (1..<rows).reversed() {
            grid[row] = grid[row - 1]
        }
        
        // Update the top row with the newly computed generation
        grid[0] = nextgen
        
        // Ensure grid updates on the main thread for SwiftUI
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    func rule110(left: WolframCellState, center: WolframCellState, right: WolframCellState) -> WolframCellState {
        // Rule 110 transition table
        switch (left, center, right) {
        case (.alive, .alive, .alive): return .dead   // 111 -> 0
        case (.alive, .alive, .dead): return .alive   // 110 -> 1
        case (.alive, .dead, .alive): return .alive   // 101 -> 1
        case (.alive, .dead, .dead): return .dead     // 100 -> 0
        case (.dead, .alive, .alive): return .alive   // 011 -> 1
        case (.dead, .alive, .dead): return .alive    // 010 -> 1
        case (.dead, .dead, .alive): return .alive    // 001 -> 1
        case (.dead, .dead, .dead): return .dead      // 000 -> 0
        }
    }
}
