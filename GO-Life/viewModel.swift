//
//  viewModel.swift
//  GO-Life
//
//  Created by Elliot Rapp on 8/22/24.
//

import Foundation
import SwiftUI
import Combine

class Model: ObservableObject {
    static let shared = Model()
    @Published var rows = 50
    @Published var columns = 27
    @Published var grid: [[CellState]] = Array(repeating: Array(repeating: .dead, count: 27), count: 50)
    @Published var resourceMap: [[Double]] = Array(repeating: Array(repeating: 0.5, count: 27), count: 50)
    @Published var isRunning = false
    @Published var selectedPattern: SelectedPattern = .blinker
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    @Published var speed: CGFloat = 0.01 {
        
        didSet {
            resetTimer()
        }
    }
    
    init() {
        
        let rows = rows
        let columns = columns
        
        // Directly assign the grid and resourceMap without using State
        grid = Array(repeating: Array(repeating: CellState.dead, count: columns), count: rows)
        resourceMap = Array(repeating: Array(repeating: 0.0, count: columns), count: rows)
        
        randomizeGrid()
        randomizeResources()
        resetTimer()
        
    }
    
    
    
    private func resetTimer() {
        timer?.upstream.connect().cancel() // Cancel the previous timer
        timer = Timer.publish(every: TimeInterval(speed), on: .main, in: .common).autoconnect()
    }
    
    
    func randomizeGrid() {
        for row in 0..<rows {
            for col in 0..<columns {
                grid[row][col] = Double.random(in: 0.0...1.0) > 0.6 ? .alive : .dead
            }
        }
    }
    
    func randomizeResources() {
        for row in 0..<rows {
            for col in 0..<columns {
                resourceMap[row][col] = Double.random(in: 0.3...1.0)
            }
        }
    }
    
    func regenerateResources() {
        for row in 0..<rows {
            for col in 0..<columns {
                resourceMap[row][col] = min(resourceMap[row][col] + 0.01, 1.0)
            }
        }
    }
    
    
    func clearGrid() {
        for row in 0..<rows {
            for col in 0..<columns {
                grid[row][col] = .dead
                print("Cell at (\(row), \(col)) set to dead")
            }
        }
        objectWillChange.send()
    }
    enum SelectedPattern {
        case blinker
        case toad
        case acorn
        case glider
        case none
    }
    
    func placePattern(at position: (row: Int, col: Int)) {
        guard position.row >= 0 && position.row < grid.count,
              position.col >= 0 && position.col < grid[position.row].count else {
            print("Invalid grid position: \(position.row), \(position.col)")
            return
        }

        switch selectedPattern {
        case .blinker:
            if position.row > 0 && position.row < grid.count - 1 {
                grid[position.row - 1][position.col] = .alive
                grid[position.row][position.col] = .alive
                grid[position.row + 1][position.col] = .alive
            }
        case .toad:
            if position.row > 0 && position.row < grid.count - 2 && position.col > 0 && position.col < grid[position.row].count - 2 {
                grid[position.row][position.col] = .alive
                grid[position.row][position.col + 1] = .alive
                grid[position.row][position.col + 2] = .alive
                grid[position.row + 1][position.col - 1] = .alive
                grid[position.row + 1][position.col] = .alive
                grid[position.row + 1][position.col + 1] = .alive
            }
        case .acorn:
            if position.row < grid.count - 2 && position.col < grid[position.row].count - 6 {
                grid[position.row][position.col + 1] = .alive
                grid[position.row + 1][position.col + 3] = .alive
                grid[position.row + 2][position.col] = .alive
                grid[position.row + 2][position.col + 1] = .alive
                grid[position.row + 2][position.col + 4] = .alive
                grid[position.row + 2][position.col + 5] = .alive
                grid[position.row + 2][position.col + 6] = .alive
            }
        case .glider:
            if position.row < grid.count - 2 && position.col < grid[position.row].count - 2 {
                grid[position.row][position.col + 1] = .alive
                grid[position.row + 1][position.col + 2] = .alive
                grid[position.row + 2][position.col] = .alive
                grid[position.row + 2][position.col + 1] = .alive
                grid[position.row + 2][position.col + 2] = .alive
            }
        case .none:
            grid[position.row][position.col] = grid[position.row][position.col] == .dead ? .alive : .dead
        }

        // Trigger an explicit UI update
        objectWillChange.send()
    }
    func startSimulation() {
        DispatchQueue.global(qos: .userInitiated).async {
            while self.isRunning {
                let newGrid = self.nextGeneration(grid: self.grid, resourceMap: self.resourceMap)
                DispatchQueue.main.async {
                    self.grid = newGrid
                }
                usleep(UInt32(self.speed * 1_000_000)) // Control speed
            }
        }
    }

    
    func nextGeneration(grid: [[CellState]], resourceMap: [[Double]]) -> [[CellState]] {
        var newGrid = grid
        for row in 0..<rows {
            for col in 0..<columns {
                let liveNeighbors = countLiveNeighbors(grid: grid, row: row, col: col)
                let currentState = grid[row][col]
                let resourceLevel = resourceMap[row][col]
                
                if currentState == .dead && liveNeighbors == 3 && resourceLevel >= 0.3 {
                    newGrid[row][col] = .alive
                } else if (currentState == .alive || currentState == .complex) && (liveNeighbors < 2 || liveNeighbors > 3 || resourceLevel < 0.2) {
                    newGrid[row][col] = .dead

                } else if currentState == .alive && liveNeighbors == 3 && resourceLevel >= 0.5 {
                    newGrid[row][col] = .complex
                }
            }
        }
        
        for row in 0..<rows {
            for col in 0..<columns {
                if isComplexPattern(grid: grid, row: row, col: col) {
                    markPatternAsComplex(grid: &newGrid, row: row, col: col)
                }
            }
        }
        
        return newGrid
    }

    func countLiveNeighbors(grid: [[CellState]], row: Int, col: Int) -> Int {
        var liveNeighbors = 0
        for i in max(0, row - 1)...min(rows - 1, row + 1) {
            for j in max(0, col - 1)...min(columns - 1, col + 1) {
                if (i != row || j != col) && (grid[i][j] == .alive || grid[i][j] == .complex) {
                    liveNeighbors += 1
                }
            }
        }
        return liveNeighbors
    }

    func isComplexPattern(grid: [[CellState]], row: Int, col: Int) -> Bool {
        let complexPatterns: [[[Bool]]] = [
            [
                [true, true],
                [true, true]
            ]
        ]
        
        for pattern in complexPatterns {
            if matchesPattern(grid: grid, row: row, col: col, pattern: pattern) {
                return true
            }
        }
        return false
    }

    func matchesPattern(grid: [[CellState]], row: Int, col: Int, pattern: [[Bool]]) -> Bool {
        for i in 0..<pattern.count {
            for j in 0..<pattern[0].count {
                let newRow = row + i
                let newCol = col + j
                if newRow >= rows || newCol >= columns {
                    return false
                }
                if pattern[i][j] && grid[newRow][newCol] != .alive {
                    return false
                }
            }
        }
        return true
    }

    func markPatternAsComplex(grid: inout [[CellState]], row: Int, col: Int) {
        let patternSize = 2
        for i in 0..<patternSize {
            for j in 0..<patternSize {
                let newRow = row + i
                let newCol = col + j

                if newRow < rows && newCol < columns {
                    grid[newRow][newCol] = .complex
                }
            }
        }
    }

}



enum CellState {
    case dead
    case alive
    case complex
    
    var color: Color {
        switch self {
        case .dead: return .black
        case .alive: return .blue
        case .complex: return .green
        }
    }
}


