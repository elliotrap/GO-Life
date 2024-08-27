//
//  GenerationsModel.swift
//  GO-Life
//
//  Created by Elliot Rapp on 8/26/24.
//

import Foundation
import SwiftUI
import Combine



enum GenerationsCellState {
    case inactive
    case excited
    case refractory
    case dormant
}
class GameOfLifeModel: ObservableObject {
    @Published var GenerationsRows: Int = 100
    @Published var GenerationsColumns: Int = 50
    @Published var grid: [[GenerationsCellState]] = Array(repeating: Array(repeating: .inactive, count: 27), count: 50)
    @Published var resourceMap: [[Double]] = Array(repeating: Array(repeating: 0.5, count: 27), count: 50)
    @Published var isRunning = false
    private var timer: AnyCancellable?
    @Published var speed: CGFloat = 0.01
    init() {
        let rows = GenerationsRows
        let columns = GenerationsColumns
        
        // Initialize grid and resourceMap
        grid = Array(repeating: Array(repeating: .inactive, count: columns), count: rows)
        resourceMap = Array(repeating: Array(repeating: 0.5, count: columns), count: rows)
        populateGridRandomly() // Optional: populate the grid with some initial excited cells
    }



    func startSimulation() {
        guard !isRunning else { return } // Do nothing if already running
        isRunning = true
        
        // Start a new timer
        timer = Timer.publish(every: TimeInterval(speed), on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateGrid()
            }
    }

    func stopSimulation() {
        guard isRunning else { return } // Do nothing if not running
        isRunning = false
        timer?.cancel()
    }
    
    func resetTimer() {
        stopSimulation() // Ensure the timer is stopped before resetting
        startSimulation()
    }


    
    private func populateGridRandomly() {
        for row in 0..<GenerationsRows {
            for col in 0..<GenerationsColumns {
                let randomValue = Double.random(in: 0..<1)
                if randomValue < 0.1 { // 10% chance to start excited
                    grid[row][col] = .excited
                } else if randomValue < 0.15 && resourceMap[row][col] > 0.7 { // 5% chance to start dormant, influenced by resourceMap
                    grid[row][col] = .dormant
                } else {
                    grid[row][col] = .inactive
                }
            }
        }
    }

    private func updateGrid() {
        var newGrid = grid

        for row in 0..<GenerationsRows {
            for col in 0..<GenerationsColumns {
                let state = grid[row][col]
                let excitedNeighbors = countExcitedNeighbors(row: row, col: col)
                let resourceInfluence = resourceMap[row][col]
                
                switch state {
                case .inactive:
                    // Probability-based transition influenced by resource map and neighbor count
                    if excitedNeighbors >= 2 && excitedNeighbors <= 4 && Double.random(in: 0..<1) < resourceInfluence * 0.5 {
                        newGrid[row][col] = .excited
                    } else if Double.random(in: 0..<1) < 0.05 {
                        newGrid[row][col] = .dormant // 5% chance to become dormant
                    }
                case .excited:
                    newGrid[row][col] = .refractory // Excited cells become refractory
                case .refractory:
                    newGrid[row][col] = .inactive // Refractory cells become inactive
                case .dormant:
                    if Double.random(in: 0..<1) < 0.1 * resourceInfluence {
                        newGrid[row][col] = .excited // Dormant cells have a 10% chance (adjusted by resourceMap) to become excited
                    }
                }
            }
        }

        grid = newGrid
    }

    private func countExcitedNeighbors(row: Int, col: Int) -> Int {
        var count = 0
        for i in -1...1 {
            for j in -1...1 {
                if i == 0 && j == 0 { continue } // Skip the cell itself
                let newRow = (row + i + GenerationsRows) % GenerationsRows
                let newCol = (col + j + GenerationsColumns) % GenerationsColumns
                if grid[newRow][newCol] == .excited {
                    count += 1
                }
            }
        }
        return count
    }
}


