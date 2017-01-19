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
    
    

import Foundation
import SoLazy

open class PageTemplateRenderer: NSObject {
    
    fileprivate override init() { }
    
    static var templateUrl: URL {
        return Bundle(for: Page.self).url(forResource: "PageTemplate", withExtension: "html")!
    }

    static func htmlStringForPage(_ page: Page) -> String {
        return htmlString(title: page.title, body: page.body ?? "")
    }
    
    open class func htmlString(title: String, body: String) -> String {
        var template = try! String(contentsOf: templateUrl, encoding: String.Encoding.utf8)
        template = template.replacingOccurrences(of: "{$TITLE$}", with: title)
        template = template.replacingOccurrences(of: "{$PAGE_BODY$}", with: body)
        
        return template
    }
    
}
