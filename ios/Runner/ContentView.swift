//
//  ContentView.swift
//  BrightWallet
//
//  Created by रोहित ठाकुर on 18/04/23.
//
import UIKit
import Flutter
import SwiftUI
import PassKit
import Firebase
import FirebaseStorage
struct ContentView: View {
    @State private var isLoading = false
    @State private var newPass: PKPass?
    @State private var passSheetVisible = false
    @State private var backgroundColor = Color.yellow
    let storageRef = Storage.storage().reference()

    func getColorHex(color: Color) -> String {
        let colorRGB = color.cgColor?.components!
        var colorHex = Color(red: Double(colorRGB![0]), green: Double(colorRGB![1]), blue: Double(colorRGB![2]), opacity: Double(colorRGB![3])).description
        colorHex = colorHex.replacingOccurrences(of: "#", with: "")
        if (colorHex == "black") {
            return "000000"
        }
        else if (colorHex == "white") {
            return "FFFFFF"
        }
        else {
            colorHex = colorHex.dropLast(2).description
            return colorHex
        }
    }

    func generatePass(completion: @escaping((Bool) -> () )) {
        let params: [String: Any] = [

            "backgroundColor": self.getColorHex(color: self.backgroundColor)
        ]

        var request = URLRequest(url: URL(string: "https://us-central1-pass-d96f3.cloudfunctions.net/pass")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                completion(json["result"]! as! String == "SUCCESS" ? true : false)
            } catch {
                print("error")
                completion(false)
            }
        }

        task.resume()
    }

    func downloadPass(completion: @escaping((Bool) -> () )) {
        self.storageRef.child("passes/custom.pkpass").getData(maxSize: Int64(1 * 1024 * 1024)) { data, error in
            if let error = error {
                print("Error downloading resource: " + error.localizedDescription)
            }
            else {
                do {
                    let canAddPassResult = PKAddPassesViewController.canAddPasses()
                    if (canAddPassResult) {
                        print("Can add passes. Proceed with creating pass.")
                        self.newPass = try PKPass.init(data: data!)
                        completion(true)
                    }
                    else {
                        print("Can NOT add pass. Abort!")
                        completion(false)
                    }
                }
                catch {
                    print("Something is wrong.")
                    completion(false)
                }
            }
        }
    }
    var body: some View {
        VStack {
            Image("card")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 46)

            Section() {
                ColorPicker("Card Color", selection: self.$backgroundColor)
                    .padding(.vertical)
            }

            Section {
                if (!self.isLoading) {
                    AddPassToWalletButton {
                        self.isLoading = true
                        self.generatePass { generatePassResult in
                            if (generatePassResult) {
                                self.downloadPass { downloadPassResult in
                                    if (downloadPassResult) {
                                        self.passSheetVisible = true
                                        self.isLoading = false
                                    }
                                    else {
                                        self.isLoading = false
                                        print("failed to download pass")
                                    }
                                }
                            }
                            else {
                                self.isLoading = false
                                print("failed to generate pass")
                            }
                        }
                    }
                    .frame(height: 60)
                }
                else {
                    ProgressView()
                }
            }
        }
        .padding()
        .sheet(isPresented: self.$passSheetVisible) {
            AddPassView(pass: self.$newPass)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
