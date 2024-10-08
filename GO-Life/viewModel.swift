//
//  viewModel.swift
//  GO-Life
//
//  Created by Elliot Rapp on 8/22/24.
//

import Foundation
import SwiftUI
import Combine

enum Rotation {
    case none, rotate90, rotate180, rotate270
}

class Model: ObservableObject {
    static let shared = Model()
    @Published var rows = 49
    @Published var columns = 27
    @Published var grid: [[CellState]] = Array(repeating: Array(repeating: .dead, count: 27), count: 49)
    @Published var resourceMap: [[Double]] = Array(repeating: Array(repeating: 0.5, count: 27), count: 49)
    
    
    @Published var miniGrid: [[CellState]] = Array(repeating: Array(repeating: .dead, count: 15), count: 15) // Mini grid state

    private var undoStack: [[(row: Int, col: Int)]] = []
    @Published var placedPattern = false
    var currentRotation: Rotation = .none

    private var fadeOutWorkItem: DispatchWorkItem? // To manage fade-out animation cancellation

    @Published var isRectangleVisible = false
    @Published var isRunning = false
    @Published var selectedPattern: SelectedPattern = .blinker
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    @Published var shadowEnabled = true
    @Published var complexColorEnabled: Bool = true
    @Published var GOL = "conway"

    @Published var showTopBottomLines = true // State to toggle top and bottom lines
    @Published var gridCounter: Int = 0
    
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
        updateMiniGrid() 
        randomizeResources()
        resetTimer()
        rotateAndMaintainVisibility()
        
    }
    

    // Rotate the pattern and reset fade-out
    func rotateAndMaintainVisibility() {
        rotatePattern()
        updateMiniGrid()

        // Cancel any existing fade-out animations
        fadeOutWorkItem?.cancel()

        // Make the rectangle visible
        withAnimation(.easeIn(duration: 0.5)) {
            isRectangleVisible = true
        }

        // Schedule a new fade-out
        let newFadeOutWorkItem = DispatchWorkItem { [weak self] in
            withAnimation(.easeOut(duration: 0.5)) {
                self?.isRectangleVisible = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: newFadeOutWorkItem)
        fadeOutWorkItem = newFadeOutWorkItem
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
        case pulsar
        case beacon
        case pentadecathlon
        case diehard
        case none
    }
    func rotatePattern() {
        // Change rotation state
        switch currentRotation {
        case .none: currentRotation = .rotate90
        case .rotate90: currentRotation = .rotate180
        case .rotate180: currentRotation = .rotate270
        case .rotate270: currentRotation = .none
        }
    }

    func applyRotation(to position: (row: Int, col: Int), offset: (dx: Int, dy: Int)) -> (Int, Int) {
        switch currentRotation {
        case .none:
            return (position.row + offset.dx, position.col + offset.dy)
        case .rotate90:
            return (position.row - offset.dy, position.col + offset.dx)
        case .rotate180:
            return (position.row - offset.dx, position.col - offset.dy)
        case .rotate270:
            return (position.row + offset.dy, position.col - offset.dx)
        }
    }
    
    func updateMiniGrid() {
        // Reset miniGrid to all dead cells
        miniGrid = Array(repeating: Array(repeating: .dead, count: 15), count: 15)

        switch selectedPattern {
        case .blinker:
            let offsets = [
                (-1, 0), (0, 0), (1, 0)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy)) // Center pattern in the mini grid
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .toad:
            let offsets = [
                (0, 0), (0, 1), (0, 2),
                (1, -1), (1, 0), (1, 1)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy)) // Center pattern in the mini grid
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .acorn:
            let offsets = [
                (0, 1), (1, 3), (2, 0), (2, 1), (2, 4), (2, 5), (2, 6)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy))
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .glider:
            let offsets = [
                (0, 1), (1, 2), (2, 0), (2, 1), (2, 2)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy))
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .beacon:
            let offsets = [
                (0, 0), (0, 1), (1, 0), (1, 1),
                (2, 2), (2, 3), (3, 2), (3, 3)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (4, 4), offset: (dx, dy))
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .pulsar:
            let offsets = [
                (-6, -4), (-6, -3), (-6, -2), (-6, 2), (-6, 3), (-6, 4),
                (-1, -4), (-1, -3), (-1, -2), (-1, 2), (-1, 3), (-1, 4),
                (1, -4), (1, -3), (1, -2), (1, 2), (1, 3), (1, 4),
                (6, -4), (6, -3), (6, -2), (6, 2), (6, 3), (6, 4),
                (-4, -6), (-3, -6), (-2, -6), (-4, -1), (-3, -1), (-2, -1),
                (-4, 1), (-3, 1), (-2, 1), (-4, 6), (-3, 6), (-2, 6),
                (2, -6), (3, -6), (4, -6), (2, -1), (3, -1), (4, -1),
                (2, 1), (3, 1), (4, 1), (2, 6), (3, 6), (4, 6)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy))
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .pentadecathlon:
            let offsets = [
                (0, -1), (0, 0), (0, 1),
                (-1, -2), (-1, 2),
                (-2, -1), (-2, 0), (-2, 1),
                (1, -2), (1, 2),
                (2, -1), (2, 0), (2, 1)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy))
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .diehard:
            let offsets = [
                (0, 6), (1, 0), (1, 1), (2, 1), (2, 5), (2, 6), (2, 7)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: (7, 7), offset: (dx, dy))
                if newRow >= 0 && newRow < miniGrid.count && newCol >= 0 && newCol < miniGrid[newRow].count {
                    miniGrid[newRow][newCol] = .alive
                }
            }

        case .none:
            // Clear mini grid for no pattern
            miniGrid = Array(repeating: Array(repeating: .dead, count: 9), count: 9)
        }
    }
    
    func placePattern(at position: (row: Int, col: Int)) {
        guard position.row >= 0 && position.row < grid.count,
              position.col >= 0 && position.col < grid[position.row].count else {
            print("Invalid grid position: \(position.row), \(position.col)")
            return
        }
        
        var currentPlacement: [(row: Int, col: Int)] = []

        placedPattern = true

        switch selectedPattern {
        case .blinker:
            let offsets = [
                (-1, 0), (0, 0), (1, 0)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .toad:
            let offsets = [
                (0, 0), (0, 1), (0, 2),
                (1, -1), (1, 0), (1, 1)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .acorn:
            let offsets = [
                (0, 1), (1, 3), (2, 0), (2, 1), (2, 4), (2, 5), (2, 6)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .glider:
            let offsets = [
                (0, 1), (1, 2), (2, 0), (2, 1), (2, 2)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .beacon:
            let offsets = [
                (0, 0), (0, 1), (1, 0), (1, 1),
                (2, 2), (2, 3), (3, 2), (3, 3)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .pulsar:
            let offsets = [
                (-6, -4), (-6, -3), (-6, -2), (-6, 2), (-6, 3), (-6, 4),
                (-1, -4), (-1, -3), (-1, -2), (-1, 2), (-1, 3), (-1, 4),
                (1, -4), (1, -3), (1, -2), (1, 2), (1, 3), (1, 4),
                (6, -4), (6, -3), (6, -2), (6, 2), (6, 3), (6, 4),
                (-4, -6), (-3, -6), (-2, -6), (-4, -1), (-3, -1), (-2, -1),
                (-4, 1), (-3, 1), (-2, 1), (-4, 6), (-3, 6), (-2, 6),
                (2, -6), (3, -6), (4, -6), (2, -1), (3, -1), (4, -1),
                (2, 1), (3, 1), (4, 1), (2, 6), (3, 6), (4, 6)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .pentadecathlon:
            let offsets = [
                (0, -1), (0, 0), (0, 1),
                (-1, -2), (-1, 2),
                (-2, -1), (-2, 0), (-2, 1),
                (1, -2), (1, 2),
                (2, -1), (2, 0), (2, 1)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }

        case .diehard:
            let offsets = [
                (0, 6), (1, 0), (1, 1), (2, 1), (2, 5), (2, 6), (2, 7)
            ]
            for (dx, dy) in offsets {
                let (newRow, newCol) = applyRotation(to: position, offset: (dx, dy))
                if newRow >= 0 && newRow < grid.count && newCol >= 0 && newCol < grid[newRow].count {
                    if grid[newRow][newCol] == .dead {
                        grid[newRow][newCol] = .alive
                        currentPlacement.append((newRow, newCol))
                    }
                }
            }
        
        
        case .none:
            if position.row >= 0 && position.row < grid.count && position.col >= 0 && position.col < grid[position.row].count {
                grid[position.row][position.col] = grid[position.row][position.col] == .dead ? .alive : .dead
            }
        }
        
        undoStack.append(currentPlacement)


        // Trigger an explicit UI update
        objectWillChange.send()
    }
    func undoLastPattern() {
        guard let lastPlacement = undoStack.popLast() else {
            print("No patterns to undo")
            return
        }

        // Revert each cell in the last pattern placement back to .dead
        for (row, col) in lastPlacement {
            grid[row][col] = .dead
        }

        // Trigger an explicit UI update
        objectWillChange.send()
    }
   
    @MainActor
    func startSimulation() {
        Task {
            while self.isRunning {
                // Perform the heavy computation in a background task
                let newGrid = await nextGeneration(grid: self.grid, resourceMap: self.resourceMap)
                
                // Update the grid on the main thread
                self.grid = newGrid

                try? await Task.sleep(nanoseconds: UInt64(self.speed * 1_000_000_000)) // Control speed with Swift concurrency
            }
        }
    }

    @MainActor
    func nextGeneration(grid: [[CellState]], resourceMap: [[Double]]) async -> [[CellState]] {
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
    
    @MainActor
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

    @MainActor
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

    @MainActor
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

    @MainActor

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


