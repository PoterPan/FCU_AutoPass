//
//  ContentView.swift
//  FCU_AutoPass
//
//  Created by Poter Pan on 2021/12/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct Home: View{
    
    @State var show_menu = false
    @State var show_setting = false
    @State var customAlert = false
    @State var show_pass = false
    @AppStorage("Name") private var Name = "未填寫"
    @State var setting = Setting()
    
    
    var body: some View{
        ZStack{
            
            VStack{
                
                Button(action: {
                    withAnimation{
                        show_pass.toggle()
                    }
                }) {
                    Image("pass_BG")
                        .resizable()
                        .scaledToFill()
                    
                }
                Button(action: {
                    show_menu = true
                }) {
                    Image("pass_Button")
                        .resizable()
                        .scaledToFit()
                }
                
                
                .actionSheet(isPresented: $show_menu) {
                    let actionSheet = ActionSheet(title: Text("設定"), message: Text("請輸入個人資料"), buttons:
                                                    [
                                                        .default(Text("姓名")){
                                                            alertView()
                                                        },
                                                        .default(
                                                            Text("顏色設定")){
                                                                self.show_menu = false
                                                                show_setting = true
                                                            },
                                                        .cancel(Text("退出"))
                                                    ]
                    )
                    return actionSheet
                }
                .sheet(isPresented: self.$show_setting, content: {
                    SettingView(setting: $setting)
                })
            }
            
            if show_pass {
                PassView(show: $show_pass, Name: $Name, setting: $setting)
            }
            //                NavigationLink(destination: SettingView(),isActive: $show_setting, setting: $setting) {
            //                    EmptyView()
            //                }
        }
        //            .navigationBarTitle("PASS")
        //            .navigationBarHidden(true)
        
    }
    
    func alertView(){
        
        let alert = UIAlertController(title: "姓名", message: "請輸入姓名使PASS完整", preferredStyle: .alert)
        
        alert.addTextField { (name) in
            
            name.placeholder = "Name"
        }
        
        // Action Buttons...
        
        let confirm = UIAlertAction(title: "確認", style: .default) { (_) in
            Name = alert.textFields![0].text!
        }
        
        let cancel = UIAlertAction(title: "取消", style: .destructive) { (_) in
            
        }
        
        // adding into alertView...
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        //presenting alertView...
        
        // in old version swiftui
        //        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
        
        keyWindow()?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
    
    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes.filter {$0.activationState == .foregroundActive}
        .compactMap { $0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }
    
}

class ColorSet {
    var today_color_r = "0"
    var today_color_g = "0"
    var today_color_b = "0"

}

struct PassView : View {
    
    @Binding var show : Bool
    @Binding var Name : String
    @Binding var setting: Setting
    var colorSet = ColorSet()


    var body: some View{

        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            

            
            VStack(spacing: 25.0){
                
                List {
                    Text("PASS")
                        .fontWeight(.bold)
                    HStack {
                        Spacer()
                        ZStack{
                            Circle()
                                .frame(width: 240, height: 240)
                                .foregroundColor(Color(red: StringToFloat(str: getColorSet()[0])/255, green: StringToFloat(str: getColorSet()[1])/255, blue: StringToFloat(str: getColorSet()[2])/255, opacity: 1.0))
                            
                            VStack {

                                
                                todayText()
                                
                                Text(Name)
                                    .font(.system(size: 20))
                                
                                Text("自主健康管理")
                                    .font(.system(size: 20))
                                
                                Text("PASS")
                                    .font(.system(size: 20))
                                    .padding(.vertical, 0.3)
                                Text("逢甲大學關心您")
                                    .font(.system(size: 10))
                                
                            }
                            .foregroundColor(Color.white)
                            
                        }
                        .padding(4)
                        Spacer()
                        
                    }
                    HStack {
//                       ForTest
//                        Text(getColorSet()[0])
//                        Text("Color_R: \(StringToFloat(str: getColorSet()[0]))")
                        Spacer()
                        Button(action: {
                            withAnimation{
                                show.toggle()
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(red: 51/255, green: 122/255, blue: 183/255, opacity: 1.0))
                                    .frame(width: 50, height: 30)
                                Text("關閉")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color.white)
                            }
                            .padding(.trailing, -10.0)
                        }
                        
                    }
                    
                    
                }
                .padding(.horizontal, -8.0)
                .padding(.trailing)
                .padding(.top, -1)
                .listStyle(.plain)
                
            }
            .frame(width: 350, height: 350)
            //            .padding(.vertical,25)
            //            .padding(.horizontal,30)
            .background(.white)
            .cornerRadius(8)
            .offset(y: -55)
            
            
            Button(action: {
                withAnimation{
                    show.toggle()
                }
            }) {
                Image("close_Button")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.black)
            }
            .offset(x: 17, y: -72)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.25)
        )
    }
    
    func todayText() -> some View {
            let today  = Date()
            let formatter = DateFormatter()

            formatter.dateFormat = "MM/dd"

            return Text(formatter.string(from: today).uppercased())
            .font(.system(size: 60))
            .padding(.bottom, 0.5)
        }
    
    func getColorSet() -> Array<String> {
        let today  = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = "E"

        var weekdayValue: String {
                return formatter.string(from: today)
            }
        
        
        let weekday = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
        
        if ( weekday[0] == weekdayValue) {
            colorSet.today_color_r = setting.color_r1
            colorSet.today_color_g = setting.color_g1
            colorSet.today_color_b = setting.color_b1
        }
        

        let ColorSet = [colorSet.today_color_r, colorSet.today_color_g, colorSet.today_color_b]
        
        return ColorSet
        
    }
    
    func StringToFloat(str:String)->(CGFloat){
     
     
     
            let string = str
     
            var cgFloat:CGFloat = 0
     
            
            if let doubleValue = Double(string)
            {
     
                cgFloat = CGFloat(doubleValue)
     
            }
     
            return cgFloat
    }
     

    
}

struct SettingView: View {
    @Binding var setting: Setting
    var body: some View{
        Form {
            Section(header: Text("Color1")){
                TextField("R", text: $setting.color_r1)
                TextField("G", text: $setting.color_g1)
                TextField("B", text: $setting.color_b1)
            }
            Section(header: Text("Color2")){
                TextField("R", text: $setting.color_r2)
                TextField("G", text: $setting.color_g2)
                TextField("B", text: $setting.color_b2)
            }
            Section(header: Text("Color3")){
                TextField("R", text: $setting.color_r3)
                TextField("G", text: $setting.color_g3)
                TextField("B", text: $setting.color_b3)
            }
            Section(header: Text("Color4")){
                TextField("R", text: $setting.color_r4)
                TextField("G", text: $setting.color_g4)
                TextField("B", text: $setting.color_b4)
            }
            Section(header: Text("Color5")){
                TextField("R", text: $setting.color_r5)
                TextField("G", text: $setting.color_g5)
                TextField("B", text: $setting.color_b5)
            }
            Section(header: Text("Color6")){
                TextField("R", text: $setting.color_r6)
                TextField("G", text: $setting.color_g6)
                TextField("B", text: $setting.color_b6)
            }
            Section(header: Text("Color7")){
                TextField("R", text: $setting.color_r7)
                TextField("G", text: $setting.color_g7)
                TextField("B", text: $setting.color_b7)
            }
            
        }
        .keyboardType(.numberPad)
//        .navigationTitle("SettingPages")
    }
}

// backgroundView...

//struct BlurView : UIViewRepresentable {
//    func makeUIView(context: Context) -> UIVisualEffectView {
//
//        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
//
//        return view
//    }
//
//    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
//
//    }
//
//}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 13 Pro")
            //            ContentView()
            //                .previewDevice("iPhone 8 Plus")
        }
    }
}
