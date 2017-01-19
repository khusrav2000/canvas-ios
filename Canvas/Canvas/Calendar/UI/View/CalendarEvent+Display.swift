//
// Copyright (C) 2016-present Instructure, Inc.
//   
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
    
    

import Foundation
import CalendarKit
import SoIconic

extension CalendarEvent {

    public func dueText() -> String {
        guard let startAt = startAt, let endAt = endAt else {
            return ""
        }

        if startAt.compare(endAt) == .orderedSame {
            return "\(CalendarEvent.dueDateFormatter.string(from: startAt))"
        }

        return "\(CalendarEvent.dueDateFormatter.string(from: startAt)) - \(CalendarEvent.dueDateFormatter.string(from: endAt))"
    }

    public func typeImage() -> UIImage {
        switch self.type {
        case .assignment:
            return .icon(.assignment)
        case .quiz:
            return .icon(.quiz)
        case .discussion:
            return .icon(.discussion)
        default:
            return .icon(.calendar)
        }
    }
}
