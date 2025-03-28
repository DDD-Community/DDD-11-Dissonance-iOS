//
//  MoyaProvider+.swift
//  DataLayer
//
//  Created by 한상진 on 3/28/25.
//  Copyright © 2025 MOZIP. All rights reserved.
//

import Moya

extension MoyaProvider {
  convenience init(plugins: [PluginType] = []) {
    let interceptor = AuthInterceptor()
    let session = ValidatingSession(interceptor: interceptor)
    self.init(session: session, plugins: plugins)
  }
  
  convenience init(session: Session) {
    self.init(session: session, plugins: [])
  }
}
