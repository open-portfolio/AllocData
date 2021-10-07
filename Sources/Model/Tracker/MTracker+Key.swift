//
//  M+Key.swift
//
// Copyright 2021 FlowAllocator LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

extension MTracker: AllocKeyed {
    public struct Key: Hashable, Comparable, Equatable {
        private let trackerIDn: String
        
        public init(trackerID: String) {
            self.trackerIDn = MTracker.normalizeID(trackerID)
        }
        
        public init(_ element: MTracker) {
            self.init(trackerID: element.trackerID)
        }

        public static func < (lhs: Key, rhs: Key) -> Bool {
            if lhs.trackerIDn < rhs.trackerIDn { return true }
            if lhs.trackerIDn > rhs.trackerIDn { return false }
            return false
        }
    }
    
    public var primaryKey: Key {
        Key(self)
    }
}

//extension MTracker: AllocKeyed1 {
//    public var primaryKey1: AllocKey {
//        MTracker.keyify(trackerID)
//    }
//}
