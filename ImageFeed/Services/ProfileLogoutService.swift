//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Konstantin on 17.06.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
  
   private init() { }

   func logout() {
      cleanCookies()
   }

   private func cleanCookies() {
      // Очищаем все куки из хранилища
       ProfileService.shared.deleteProfile()
       ProfileImageService.shared.deleteProfileAvatar()
       ImagesListService.shared.photos = []
       OAuth2TokenStorage.shared.deleteToken()
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
      // Запрашиваем все данные из локального хранилища
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
         // Массив полученных записей удаляем из хранилища
           records.forEach { record in
               WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
         }
      }
   }
}
