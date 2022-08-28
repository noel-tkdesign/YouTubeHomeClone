//
//  Home.swift
//  SwipeHiddenHeader
//
//  Created by Koji Kawakami on 2022/07/21.
//

import SwiftUI

struct Home: View {
    
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction:SwipeDirection = .none
    
    @State var shiftOffset: CGFloat = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            Thumbnails()
                .padding(.top,headerHeight)
                .offsetY{ previous,current in
                    if previous > current{
                      //  print("Up")
                        if direction != .up{
                            shiftOffset = current
                            direction = .up
                            lastHeaderOffset = headerHeight
                        }
                        let offset = current < 0 ? (current - shiftOffset) : 0
                        
                        headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                        
                    } else {
                        //print("Down")
                        if direction != .down{
                            shiftOffset = current
                            direction = .down
                            lastHeaderOffset = headerHeight
                        }
                        
                        let offset = lastHeaderOffset + (current - shiftOffset)
                        headerOffset = (offset > 0 ? 0 : offset)
                    }
                }
        }
        .coordinateSpace(name: "SCROLL")
        .overlay(alignment: .top){
            HeaderView()
                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){$0}
                .overlayPreferenceValue(HeaderBoundsKey.self){ value in
                    GeometryReader{proxy in
                        if let anchor = value{
                            Color.clear
                                .onAppear{
                                    headerHeight = proxy[anchor].height
                                }
                        }
                    }
                }
                .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
        }
        .ignoresSafeArea(.all, edges: .top)
    }
    @ViewBuilder
    func HeaderView()->some View{
        VStack(spacing: 16){
            VStack(spacing: 0){
                HStack{
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                    HStack(spacing: 18){
                        ForEach(["Shareplay","Notifications","Search"],id:\.self){icon in
                            Button{
                                
                            }label: {
                                Image(icon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 23, height: 23)
                                    .foregroundColor(.black)
                            }
                        }
                       
                        Button{
                            
                        }label: {
                            Image("Pic")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                        }
                            
                           
                            
                    }
                    .frame(maxWidth:.infinity,alignment: .trailing)
                }
                .padding(.bottom,6)
                
                Divider()
                    .padding(.horizontal,-15)
            }
            .padding([.horizontal,.top],10)
            TagView()
                .padding(.bottom,10)
        }
        .padding(.top,safeArea().top)
        .background{
            Color.white
            .ignoresSafeArea()
        }
        .padding(.bottom,20)
    }
    @ViewBuilder
    func TagView()->some View{
        let tag = ["All","King Halo","Haru Urara","Ogle Cap","Eisinn Flash"]
        ScrollView(.horizontal,showsIndicators: false){
            HStack(spacing: 10){
                ForEach(tag,id:\.self){ tag in
                    
                    Button{
                        
                    }label: {
                        Text(tag)
                            .font(.callout)
                            .foregroundColor(.black)
                            .padding(.vertical,6)
                            .padding(.horizontal,12)
                            .background(
                                Capsule()
                                    .fill(.black.opacity(0.08))
                            )
                    }
                    
                }
            }
            .padding(.horizontal,15)
        }
    }
    @ViewBuilder
    func Thumbnails()->some View{
        VStack(spacing: 20){
            ForEach(0...10,id:\.self){ index in
                GeometryReader{proxy in
                    let size = proxy.size
                    
                    Image("Image\((index % 5) + 1)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height:size.height )
                        .clipped()
                }
                .frame(height: 200)
                .padding(.horizontal)
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum SwipeDirection{
    case up
    case down
    case none
}
