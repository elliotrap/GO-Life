//
//  ContentView.swift
//  GO-Life
//
//  Created by Elliot Rapp on 8/22/24.
//

import SwiftUI

import SwiftUI


struct GameOfLifeView: View {
    @ObservedObject var viewModel = Model.shared


    
    @State private var originalMenuHeight: CGFloat = 100
    @State private var originalMenuPadding: CGFloat = 10
    @State private var originalChevronPadding: CGFloat = 10
    
    @State private var menuHeight: CGFloat = 100
    @State private var menuPadding: CGFloat = 10
    @State private var chevronPadding: CGFloat = 10
    
    @State private var chevronPressed = false
    @State private var hz = false
    @State private var patterns = false




     var body: some View {
        GeometryReader { geometry in
            VStack {
             // Push the GridView down

                VStack {
                    Spacer() // Push the GridView down

                  
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.black)
                                .frame(width: geometry.size.width * 0.97, height: geometry.size.height * 0.875) // Adjusted
                            
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundColor(Color("graphBackground"))
                                .frame(width: geometry.size.width * 0.949, height: geometry.size.height * 0.865) // Adjusted

                            GridView(grid: $viewModel.grid, resourceMap: $viewModel.resourceMap, cellSize: geometry.size.width * 0.5)
                                .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2) // Adjusted width and height proportionally
                        }
                    

                    Spacer()
                        .frame(height: geometry.size.height * 0.026)
                }

                ZStack {
                    ZStack {
                    
                            CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 50, bottomRightRadius: 50)
                                .foregroundColor(Color("menu"))
                                .frame(width: geometry.size.width * 0.945, height: menuHeight)
                                .opacity(0.8)
                                .padding(.bottom, menuPadding)
                            
                        
                        if chevronPressed && patterns == false, hz == false {
                            ScrollView {
                                Spacer()
                                    .frame(height: geometry.size.height * 0.06)
                                VStack(spacing: 20) {
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        Button(action: {
                                            hz = true
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))

                                                Text("Speed")
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                     
                                        
                                    }
                                    
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        
                                        Button(action: {
                                            patterns = true
                                            viewModel.selectedPattern = .acorn
                                            
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("Patterns")
                                                    .underline(false)
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                                    }
                                    
                                    
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        Button(action: {
                                            viewModel.selectedPattern = .none
                                            
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("None")
                                                    .underline(false)
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                                    }
                                    
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        
                                        Button(action: {}, label: {
                                            
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("Object")
                                                    .underline(false)
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                                    }
                                }
                            }
                            
                        } else if hz, chevronPressed {
                            ScrollView {
                                Spacer()
                                    .frame(height: geometry.size.height * 0.1)
                                VStack(spacing: 20) {
                                    
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        Button(action: {
                                            viewModel.speed = 0.01
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("0.01")
                                                    .underline(false)
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                                    }
                                    
                                    
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        Button(action: {
                                            viewModel.speed = 0.5
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("0.5")
                                                    .underline(false)
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                                    }
                                    
                                    
                                    VStack(spacing: 0) {
                                        CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(Color(.blue))
                                            .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                            .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                        Button(action: {
                                            viewModel.speed = 1.0
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("1.0")
                                                    .underline(false)
                                                    .foregroundColor(.black)
                                            }
                                        })
                                        .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                        .buttonStyle(.borderless)
                                    }
                                }
                            }
                        } else if chevronPressed, patterns  {
                                    
                                ScrollView {
                                    Spacer()
                                        .frame(height: geometry.size.height * 0.06)
                                    VStack(spacing: 20) {
                                        VStack(spacing: 0) {
                                            CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                                .foregroundColor(Color(.blue))
                                                .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                                .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                            Button(action: {
                                                viewModel.selectedPattern = .blinker
                                            }, label: {
                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))

                                                    Text("Blinker")
                                                        .foregroundColor(.black)
                                                }
                                            })
                                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                            .buttonStyle(.borderless)
                         
                                            
                                        }
                                        
                                        VStack(spacing: 0) {
                                            CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                                .foregroundColor(Color(.blue))
                                                .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                                .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                            
                                            Button(action: {
                                                patterns = true
                                                viewModel.selectedPattern = .toad
                                                
                                            }, label: {
                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("Toad")
                                                        .underline(false)
                                                        .foregroundColor(.black)
                                                }
                                            })
                                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                            .buttonStyle(.borderless)
                                        }
                                        
                                        
                                        VStack(spacing: 0) {
                                            CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                                .foregroundColor(Color(.blue))
                                                .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                                .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                            Button(action: {
                                                viewModel.selectedPattern = .acorn
                                                
                                            }, label: {
                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("Acorn")
                                                        .underline(false)
                                                        .foregroundColor(.black)
                                                }
                                            })
                                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                            .buttonStyle(.borderless)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                                .foregroundColor(Color(.blue))
                                                .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                                .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                            
                                            Button(action: {
                                                viewModel.selectedPattern = .gosperGliderGun
                                            }, label: {

                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("Glider")
                                                        .underline(false)
                                                        .foregroundColor(.black)
                                                }
                                            })
                                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                            .buttonStyle(.borderless)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                                .foregroundColor(Color(.blue))
                                                .shadow(color: .blue, radius: 5, x: 3, y: -5)
                                                .frame(width: geometry.size.width * 0.70, height: geometry.size.height * 0.006)
                                            
                                            Button(action: {
                                                viewModel.selectedPattern = .gosperGliderGun
                                            }, label: {

                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("Glider")
                                                        .underline(false)
                                                        .foregroundColor(.black)
                                                }
                                            })
                                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                            .buttonStyle(.borderless)
                                        }
                                    }

                            }
                        }
                    }
                    
                    VStack {
                        Button(action: {
                            withAnimation(.spring(duration: 0.2, blendDuration: 0.5)) {
                                if chevronPressed  {
                                    
                                    // Collapse the menu back to its original state
                                    menuHeight = originalMenuHeight
                                    menuPadding = originalMenuPadding
                                    chevronPadding = originalChevronPadding
                      
                                } else {
                                    // Expand the menu
                                    menuHeight = geometry.size.height * 0.5 // Adjusted based on screen height
                                    menuPadding = geometry.size.height * 0.382 // Adjusted padding proportionally
                                    chevronPadding = geometry.size.height * 0.80
                                    
                                    hz = false
                                    patterns = false
                                }
                                chevronPressed.toggle()
                            }
                        }, label: {
                            if chevronPressed {
                                
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.01)
                                    .foregroundColor(.black)
                            
                                    
                            } else {
                                Image(systemName: "chevron.up")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.01)
                                    .foregroundColor(.black)

                            }
                        })
                        .buttonStyle(.borderless)
                        .padding(.bottom, chevronPadding)
                        
                        if chevronPressed == false {

                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 00, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.green))
                                        .shadow(color: .green, radius: 5, x: -3, y: -5)
                                        .frame(width: geometry.size.width * 0.2843, height: geometry.size.height * 0.004)
                                    
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.blue))
                                        .shadow(color: .blue, radius: 7, x: 0, y: -5)
                                        .frame(width: geometry.size.width * 0.282, height: geometry.size.height * 0.004)
                                    
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.red))
                                        .shadow(color: .red, radius: 5, x: 3, y: -5)
                                        .frame(width: geometry.size.width * 0.2843, height: geometry.size.height * 0.004)
                                }
                        HStack(spacing: 0) {
                                
                              
                                ZStack {
                                    
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 18, bottomRightRadius: 0)
                                        .foregroundColor(Color("menuButtons"))
                                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
                                    
                                    Button(action: {
                                        viewModel.isRunning.toggle()
                                                 if viewModel.isRunning {
                                                     viewModel.startSimulation()
                                                 }                                    }, label: {
                                        Text(viewModel.isRunning ? "Pause" : "Start")
                                            .underline(false)
                                            .foregroundColor(.green)

                                    })
                                    .buttonStyle(.borderless)
                                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
                                    
                                    
                                }

                                ZStack {
                                    
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color("menuButtons"))
                                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                    
                                    Button(action: {
                                        viewModel.randomizeGrid()
                                        viewModel.randomizeResources()
                                    }, label: {
                                        Text("Randomize")
                                            .underline(false)
                                            .foregroundColor(.blue)

                                        
                                    })
                                    .buttonStyle(.borderless)
                                    .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.045)
                                    
                                }
                                    ZStack {
                                        
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 20)
                                            .foregroundColor(Color("menuButtons"))
                                        
                                            .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
                                        
                                        Button(action: {
                                            viewModel.isRunning = false // Stop the simulation
                                            
                                            // Ensure grid clearing happens immediately after stopping the simulation
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                viewModel.clearGrid()
                                            }
                                        }, label: {
                                            Text("Clear")
                                                .underline(false)
                                                .foregroundColor(.red)

                                            
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
                                        
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, geometry.size.height * 0.02) // Adjust padding proportionally
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1) // Adjust height as needed

            }
            .onReceive(viewModel.timer!) { _ in
                if viewModel.isRunning {
                    viewModel.regenerateResources()
                }
            }
    
        }
        .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("background"), Color(.black)]), // Define the colors
                    startPoint: .top, // Define the start point
                    endPoint: .bottom // Define the end point
                )
            )    }
    

}



struct GridView: View {
    @ObservedObject var viewModel = Model.shared
    @Binding var grid: [[CellState]]
    @Binding var resourceMap: [[Double]]
    let cellSize: CGFloat

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.0060) {
                ForEach(0..<grid.count, id: \.self) { row in
                    HStack(spacing: geometry.size.width * 0.0060) {
                        ForEach(0..<grid[row].count, id: \.self) { col in
                            let cellColor = colorForCellState(grid[row][col])

                            CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 0)
                                .foregroundColor(cellColor)
                                .applyShadowBasedOnColor(cellColor)
                                .frame(width: geometry.size.width * 0.08, height: geometry.size.height * 0.08)
                                .onTapGesture {

                                        viewModel.placePattern(at: (row, col))
                                    
                                }
                                
                                .cornerRadius(3)
                                .applyShadowBasedOnColor(cellColor)
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // Center content within GridView

        }
    }

    func colorForCellState(_ state: CellState) -> Color {
        switch state {
        case .alive:
            return .blue
        case .dead:
            return .black
        case .complex:
            return .green
        }
    }

    
    func cellColorForRow(_ row: Int, col: Int) -> Color {
        return colorForCellState(grid[row][col])
    }
    
    // Function to start the next generation calculation on a background thread
    func calculateNextGeneration() {
        DispatchQueue.global(qos: .userInitiated).async {
            let newGrid = viewModel.nextGeneration(grid: self.grid, resourceMap: self.resourceMap)
            DispatchQueue.main.async {
                self.grid = newGrid
            }
        }
    }
}

struct CustomRoundedRectangle: Shape {
    var topLeftRadius: CGFloat = 10.0
    var topRightRadius: CGFloat = 10.0
    var bottomLeftRadius: CGFloat = 10.0
    var bottomRightRadius: CGFloat = 10.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Top Left Corner
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        
        // Top Right Corner
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + topRightRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        
        // Bottom Right Corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRightRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - bottomRightRadius, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.maxY)
        )
        
        // Bottom Left Corner
        path.addLine(to: CGPoint(x: rect.minX + bottomLeftRadius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - bottomLeftRadius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        
        path.closeSubpath()
        
        return path
    }
}

extension View {
    // Extension to apply shadow based on color
    func applyShadowBasedOnColor(_ color: Color) -> some View {
        let shadowColor: Color
        switch color {
        case .green:
            shadowColor = .green
        case .blue:
            shadowColor = .blue
        case .black:
            shadowColor = .clear // No shadow for black cells
        default:
            shadowColor = .gray // Default shadow color if needed
        }
        
        return self.shadow(color: shadowColor, radius: 15, x: -5, y: -5)
    }
}


#Preview {
    GameOfLifeView()
}
