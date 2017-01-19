//
// Copyright (C) 2016-present Instructure, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
    
    

import TooLegit
import SoLazy

open class TodoAPI {
    open class func getTodos(_ session: Session) throws -> URLRequest {
        let path = "/api/v1/users/self/todo"
        return try session.GET(path)
    }

    open class func ignoreTodo(_ session: Session, todo: Todo) throws -> URLRequest {
        var request = URLRequest(url: URL(string: todo.ignoreURL)!)
        request.httpMethod = "DELETE"
        if let token = session.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
