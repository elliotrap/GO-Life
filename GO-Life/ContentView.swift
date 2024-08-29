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
    @ObservedObject var generationsModel = GameOfLifeModel.shared
    @ObservedObject var wolframModel = WolframModel.shared

    
    @State private var originalMenuHeight: CGFloat = 100
    @State private var originalMenuPadding: CGFloat = 10
    @State private var originalChevronPadding: CGFloat = 10
    
    @State private var menuHeight: CGFloat = 100
    @State private var menuPadding: CGFloat = 10
    @State private var chevronPadding: CGFloat = 10
    
    @State private var chevronPressed = false
    @State private var hz = false
    @State private var patterns = false
    @State private var algorithms = false
    
    @State private var isRunning = false



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

                            GridView(grid: $viewModel.grid, GenerationsGrid: $generationsModel.grid, WolframsGrid: $wolframModel.grid, resourceMap: $viewModel.resourceMap, cellSize: geometry.size.width * 0.5)
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
                            
                        
                  
                        
                        if chevronPressed && patterns == false, hz == false, algorithms == false {
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
                                            algorithms = true
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))

                                                Text("Algorithms")
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
                                            viewModel.shadowEnabled.toggle()
                                            viewModel.complexColorEnabled.toggle()
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("Graphics")
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
                                            hz = true
                                        }, label: {
                                            
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("Speed")
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
                                                viewModel.updateMiniGrid()
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
                                                viewModel.updateMiniGrid()

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
                                                viewModel.updateMiniGrid()

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
                                                viewModel.selectedPattern = .beacon
                                                viewModel.updateMiniGrid()
                                            }, label: {

                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("Beacon")
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
                                                viewModel.selectedPattern = .pulsar
                                                viewModel.updateMiniGrid()
                                            }, label: {

                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("pulsar")
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
                                                viewModel.selectedPattern = .pentadecathlon
                                                viewModel.updateMiniGrid()
                                            }, label: {

                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("Pentadecathlon")
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
                                                viewModel.selectedPattern = .diehard
                                                viewModel.updateMiniGrid() 
                                            }, label: {

                                                ZStack {
                                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                        .fill(Color("button"))
                                                    Text("queenBeeShuttle")
                                                        .underline(false)
                                                        .foregroundColor(.black)
                                                }
                                            })
                                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.08)
                                            .buttonStyle(.borderless)
                                        }
                                    }

                            }
                                .frame(height: geometry.size.height * 0.400)
                                .padding(.bottom, geometry.size.height * 0.450)
                        } else if chevronPressed, algorithms {
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
                                            viewModel.GOL = "conway"
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("Conways Game Of Life")
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
                                            viewModel.GOL = "generations"

                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("Generations Simulation")
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
                                        }, label: {
                                            ZStack {
                                                CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 25, bottomRightRadius: 25)
                                                    .fill(Color("button"))
                                                Text("")
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
                        
                        Button(action: {
                            
                            viewModel.rotateAndMaintainVisibility()
                           
                       
                        }, label: {
                            Image(systemName: "rotate.left.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 18))
                                .padding(.bottom, 3)
                        })
      
                        .frame(width: geometry.size.width * 0.080, height: geometry.size.height * 0.040)
                        .background(Color(.black))
                        .cornerRadius(5)
                        .position(x: geometry.size.width - (geometry.size.width * 0.85), y: geometry.size.height - (geometry.size.height * 0.97))
                    }
      

                    VStack {
      

                        
                        HStack {
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
                                        algorithms = false
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
                        }
                        if chevronPressed == false {
                            if viewModel.GOL == "conway" {
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
                                                }
                                     
                                            
                                        }, label: {
                                            Text(isRunning ? "Pause" : "Start")
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
                                            generationsModel.populateGridRandomly()
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
                                            
                                            if viewModel.placedPattern {
                                                viewModel.rotatePattern()
                                                viewModel.updateMiniGrid()

                                            } else {
                                                viewModel.isRunning = false // Stop the simulation
                                                
                                                // Ensure grid clearing happens immediately after stopping the simulation
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                    viewModel.clearGrid()
                                                }
                                                
                                            }
                                        }, label: {
                                            Text(viewModel.placedPattern ? "Undo" : "Clear")
                                                .underline(false)
                                                .foregroundColor(.red)
                                            
                                            
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
                                        
                                    }
                                }
                                }
                        } else if viewModel.GOL == "generations" {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 00, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.green))
                                        .shadow(color: .green, radius: 5, x: -3, y: -5)
                                        .frame(width: geometry.size.width * 0.347, height: geometry.size.height * 0.004)
                                    
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.blue))
                                        .shadow(color: .blue, radius: 7, x: 0, y: -5)
                                        .frame(width: geometry.size.width * 0.347, height: geometry.size.height * 0.004)
                                    
                             
                                }
                               
                                HStack(spacing: 0) {
                                    
                                    
                                    ZStack {
                                        
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 18, bottomRightRadius: 0)
                                            .foregroundColor(Color("menuButtons"))
                                            .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                        
                                        Button(action: {
                                      
                                                if generationsModel.isRunning {
                                                    generationsModel.togglePause()
                                                    isRunning.toggle()
                                                } else {
                                                    generationsModel.startSimulation()
                                                    isRunning.toggle()
                                                }
                                            
                                            
                                        }, label: {
                                            Text(isRunning ? "Pause" : "Start")
                                                .underline(false)
                                                .foregroundColor(.green)
                                            
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                        
                                        
                                    }
                                    
                                    ZStack {
                                        
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 18)
                                            .foregroundColor(Color("menuButtons"))
                                            .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                        
                                        Button(action: {
                                            viewModel.randomizeGrid()
                                            viewModel.randomizeResources()
                                            generationsModel.populateGridRandomly()
                                        }, label: {
                                            Text("Randomize")
                                                .underline(false)
                                                .foregroundColor(.blue)
                                            
                                            
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.045)
                                        
                                    }
    
                                }
                                }
                        } else if viewModel.GOL == "wolfram" {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    CustomRoundedRectangle(topLeftRadius: 5, topRightRadius: 00, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.green))
                                        .shadow(color: .green, radius: 5, x: -3, y: -5)
                                        .frame(width: geometry.size.width * 0.347, height: geometry.size.height * 0.004)
                                    
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 5, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(Color(.blue))
                                        .shadow(color: .blue, radius: 7, x: 0, y: -5)
                                        .frame(width: geometry.size.width * 0.347, height: geometry.size.height * 0.004)
                                    
                             
                                }
                               
                                HStack(spacing: 0) {
                                    
                                    
                                    ZStack {
                                        
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 18, bottomRightRadius: 0)
                                            .foregroundColor(Color("menuButtons"))
                                            .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                        
                                        Button(action: {
                                            if isRunning {
                                                   wolframModel.timer?.cancel()
                                                   isRunning = false
                                               } else {
                                                   wolframModel.startSimulation()
                                                   isRunning = true
                                               }
                                        }, label: {
                                            Text(isRunning ? "Pause" : "Start")
                                                .underline(false)
                                                .foregroundColor(.green)
                                            
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                        
                                        
                                    }
                                    
                                    ZStack {
                                        
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 18)
                                            .foregroundColor(Color("menuButtons"))
                                            .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.05)
                                        
                                        Button(action: {
                                            viewModel.randomizeGrid()
                                            viewModel.randomizeResources()
                                            generationsModel.populateGridRandomly()
                                        }, label: {
                                            Text("Randomize")
                                                .underline(false)
                                                .foregroundColor(.blue)
                                            
                                            
                                        })
                                        .buttonStyle(.borderless)
                                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.045)
                                        
                                    }
    
                                }
                                }
                        }
                        }
                    }
                    .padding(.bottom, geometry.size.height * 0.0) // Adjust padding proportionally
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
    @ObservedObject var gameModel = GameOfLifeModel.shared
    @ObservedObject var viewModel = Model.shared
    @ObservedObject var wolframModel = WolframModel.shared

    @Binding var grid: [[CellState]]
    @Binding var GenerationsGrid: [[GenerationsCellState]]
    @Binding var WolframsGrid: [[WolframCellState]]

    @Binding var resourceMap: [[Double]]
    let cellSize: CGFloat

    
    var body: some View {
        GeometryReader { geometry in
            
            if viewModel.GOL == "conway" {
                
                
                ZStack {
                    // Main grid displaying the Game of Life algorithm visualization
                    VStack(spacing: geometry.size.height * 0.0060) {
                        ForEach(0..<grid.count, id: \.self) { row in
                            HStack(spacing: geometry.size.width * 0.0060) {
                                ForEach(0..<grid[row].count, id: \.self) { col in
                                    let cellColor = colorForCellState(grid[row][col], complexColorEnabled: viewModel.complexColorEnabled)
                                    CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 0)
                                        .foregroundColor(cellColor)
                                        .applyShadowBasedOnColor(cellColor, isShadowEnabled: viewModel.shadowEnabled)
                                        .frame(width: geometry.size.width * 0.081, height: geometry.size.height * 0.082)
                                        .onTapGesture {
                                            viewModel.placePattern(at: (row, col))
                                        }
                                        .cornerRadius(3)
                                        .applyShadowBasedOnColor(cellColor, isShadowEnabled: viewModel.shadowEnabled)
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // Center content within GridView
                    
                    // Grid-like pattern forming a vertical line for the "X" shape
                    VStack(spacing: geometry.size.height * 0.027) {
                        ForEach(0..<90, id: \.self) { row in
                            Rectangle()
                                .fill(Color.red.opacity(0.5)) // Set the fill color with opacity
                                .frame(width: geometry.size.width * 0.015, height: geometry.size.height * 0.021)
                                .allowsHitTesting(false) // Make the rectangle translucent to touch events
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // Center vertically
                    
                    // Grid-like pattern forming a horizontal line for the "X" shape
                    HStack(spacing: geometry.size.height * 0.027) {
                        ForEach(0..<50, id: \.self) { row in
                            Rectangle()
                                .fill(Color.red.opacity(0.5)) // Set the fill color with opacity
                                .frame(width: geometry.size.width * 0.021, height: geometry.size.height * 0.015)
                                .allowsHitTesting(false) // Make the rectangle translucent to touch events
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center) // Center horizontally
                    
                    if viewModel.isRectangleVisible {
                        
                        ZStack {
                            Rectangle()
                                .frame(width: geometry.size.width * 0.56, height: geometry.size.height * 0.59)
                            // Smaller grid in the bottom-right corner showing pattern orientation
                            VStack(spacing: geometry.size.height * 0.007) {
                                ForEach(0..<15, id: \.self) { row in
                                    HStack(spacing: geometry.size.height * 0.007) {
                                        ForEach(0..<15, id: \.self) { col in
                                            Rectangle()
                                                .fill(viewModel.miniGrid[row][col] == .alive ? Color.white : Color.red.opacity(0.5))
                                            
                                                .frame(width: geometry.size.width * 0.031, height: geometry.size.height * 0.032)
                                                .allowsHitTesting(false) // Make the rectangle translucent to touch events
                                        }
                                    }
                                }
                            }
                            
                        }
                        .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.4)
                        .position(x: geometry.size.width + (geometry.size.width * 0.35), y: geometry.size.height + (geometry.size.height * 1.32)) // Position to bottom-right corner
                        
                    }
                }
            } else if viewModel.GOL == "generations" {
                
                VStack {
                        VStack(spacing: geometry.size.height * 0.0060) {
                            ForEach(0..<gameModel.grid.count, id: \.self) { generationsRow in
                                HStack(spacing: geometry.size.width * 0.0060) {
                                    ForEach(0..<gameModel.grid[generationsRow].count, id: \.self) { generationsColumn in
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .foregroundColor(self.color(for: self.gameModel.grid[generationsRow][generationsColumn])) 

                                            .frame(width: geometry.size.width * 0.041, height: geometry.size.height * 0.037)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            } else if viewModel.GOL == "wolfram" {
                VStack {
                        VStack(spacing: geometry.size.height * 0.0030) {
                            ForEach(0..<wolframModel.grid.count, id: \.self) { row in
                                HStack(spacing: geometry.size.width * 0.0030) {
                                    ForEach(0..<wolframModel.grid[row].count, id: \.self) { column in
                                        CustomRoundedRectangle(topLeftRadius: 0, topRightRadius: 0, bottomLeftRadius: 0, bottomRightRadius: 0)
                                            .fill(wolframModel.grid[row][column] == .alive ? Color.blue : Color.black)
                                            .frame(width: geometry.size.width * 0.021, height: geometry.size.height * 0.0185)
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    
                }
            }
            }
        }
    
    // Define the color(for:) method in the same struct
    private func color(for state: GenerationsCellState) -> Color {
        switch state {
        case .inactive:
            return .brown
        case .excited:
            return .blue
        case .refractory:
            return .blue
        case .dormant:
            return .green
        }
    }
    
    func cellColorForRow(_ row: Int, col: Int, complexColorEnabled: Bool) -> Color {
        return colorForCellState(grid[row][col], complexColorEnabled: complexColorEnabled)
    }
    
    // Function to start the next generation calculation on a background thread
    func calculateNextGeneration() {
        Task.detached {
            // No need for weak self since GridView is a value type (likely a struct)

            // Perform the heavy computation in a background task
            let newGrid = await viewModel.nextGeneration(grid: self.grid, resourceMap: self.resourceMap)

            // Update the grid on the main thread
            await MainActor.run {
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
    // Extension to apply shadow based on color with an enable/disable option
    func applyShadowBasedOnColor(_ color: Color, isShadowEnabled: Bool) -> some View {
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

        // Use Group to keep the return type consistent
        return Group {
            if isShadowEnabled {
                self.shadow(color: shadowColor, radius: 15, x: -5, y: -5)
            } else {
                self
            }
        }
    }
}

func colorForCellState(_ state: CellState, complexColorEnabled: Bool) -> Color {
    guard complexColorEnabled else {
        // Return a default color if complex colors are disabled
        return state == .dead ? .black : .blue
    }

    switch state {
    case .alive:
        return .blue
    case .dead:
        return .black
    case .complex:
        return .green
    }
}
#Preview {
    GameOfLifeView()
}
