//
//  AppDelegate.swift
//  GiphySwift-Example
//
//  Created by Matias Seijas on 9/14/16.
//  Copyright © 2016 Matias Seijas. All rights reserved.
//

import UIKit
import GiphySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Giphy.configure(with: .public)
        
//        Giphy.Gif.request(.trending) {
//        Giphy.Gif.request(.translate("hello")) {
//        Giphy.Gif.request(.withId("feqkVgjJpYtjy")) {
//        Giphy.Gif.request(.withIds(["feqkVgjJpYtjy", "7rzbxdu0ZEXLy"])) {
//        Giphy.Gif.request(.random(tag: "britney")) {
//        Giphy.Sticker.request(.trending) {
//        Giphy.Sticker.request(.translate("hello")) {
//        Giphy.Sticker.request(.search("britney")) {
        Giphy.Sticker.request(.random(tag: "hello")) {
            (requestResult) in
            switch requestResult {
            case .success(let result, let properties):
                print("** RESULT **")
                print(result)
                
                print("** PROPERTIES **")
                print(properties)
                case .error(let error): print("^ ERROR: \(error)")
            }
        }
        
        return true
    }

}

