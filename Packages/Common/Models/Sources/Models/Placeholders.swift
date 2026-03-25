//
//  Placeholders.swift
//  BdslClient
//
//  Created by Oleh Rozkvas on 04.03.2026.
//

import Foundation

public extension AvatarDTO {
    static func previewValue(
        id: String = "1",
        small: String = "/i/a/bot/610817deb2723b1f88327b65.AQAD5bIxGwiIUEkAAQ.160x160.jpg",
        medium: String = "/i/a/bot/610817deb2723b1f88327b65.AQAD5bIxGwiIUEkAAQ.160x160.jpg",
        large: String = "/i/a/bot/610817deb2723b1f88327b65.AQAD5bIxGwiIUEkAAQ.640x640.jpg"
    ) -> Self {
        // Some DTOs may only expose `init(from:)` via Decodable. Build one via JSON for previews.
        let json: [String: Any] = [
            "_id": id,
            "small": small,
            "medium": medium,
            "large": large
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        return try! JSONDecoder().decode(AvatarDTO.self, from: data)
    }
}

public extension ContactDTO {
    static func previewValue(
        _id: String = "1",
        phone: String = "+380981234567",
        telegram: String = "@previewUser",
        email: String = "previewUser@gmail.com"
    ) -> Self {

        let json: [String: Any] = [
            "_id": _id,
            "phone": phone,
            "telegram": telegram,
            "email": email
        ]

        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        return try! JSONDecoder().decode(ContactDTO.self, from: data)
    }
}

public extension UserDTO {
    static func previewValue(
        id: String = "123",
        name: String = "123",
        surname: String = "123",
        fullName: String = "123 123",
        role: String = "123",
        contacts: ContactDTO = ContactDTO.previewValue(),
        avatar: AvatarDTO? = AvatarDTO.previewValue()
    ) -> Self {
        // Some DTOs may only expose `init(from:)` via Decodable. Build one via JSON for previews.
        let json: [String: Any] = [
            "_id": id,
            "name": name,
            "surname": surname,
            "fullName": fullName,
            "role": role,
            "contacts": [
                "_id": contacts._id,
                "phone": contacts.phone,
                "telegram": contacts.telegram,
                "email": contacts.email
            ],
            "avatar": avatar.map { [
                "_id": $0.id,
                "small": $0.small,
                "medium": $0.medium,
                "large": $0.large
            ] }
        ]
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        return try! JSONDecoder().decode(UserDTO.self, from: data)
    }
}

public extension UserSubscription {
    static func placeholder() -> Self {
        UserSubscription(id: UUID().uuidString,
                         activities: [],
                         visitsIds: [],
                         userId: "",
                         title: "Month of Zouk and Bachata",
                         startDate:
                            Calendar.current.date(
                                byAdding: .day,
                                value: -1,
                                to: .now
                            )!,
                         endDate:
                            Calendar.current.date(
                                byAdding: .day,
                                value: 1,
                                to: .now
                            )!,
                         unlimited: false,
                         visitsLimit: 16,
                         paymentMethod: .cash,
                         price: 1600,
                         closed: nil,
                         category: .volonteer)
    }
}

public extension AttendeeModel {
    static func placeholder() -> Self {
        AttendeeModel(id: UUID().uuidString,
                      event: .placeholder(),
                      enrollTime: Date.now
        )
    }
}

public extension EventModel {
    static func placeholder() -> Self {
        EventModel(id: "123",
                   teachers: [],
                   type: .group,
                   weeklyReccurance: WeeklyRecurrence.previewValue(),
                   startDate: Date.now,
                   endDate: Date.now,
                   location: Location.previewValue(),
                   level: Level.previewValue(),
                   title: "Bachata Month",
                   activity: Activity.previewValue())
    }
}

public extension GroupModel {
    static func placeholder() -> Self {
        GroupModel(id: UUID().uuidString,
                   teachers: [],
                   type: .group,
                   startDate: Date.now,
                   endDate: Date.now,
                   recurrence: WeeklyRecurrence.previewValue(),
                   location: Location.previewValue(),
                   level: Level.previewValue(),
                   title: "Bachata Month",
                   activity: Activity.previewValue(),
                   duration: 60
        )
    }
}

public extension Level {
    static func previewValue() -> Self {
        .init(
            id: "id",
            colorHex: "#00ff00",
            title: "A1"
        )
    }
}

public extension Location {
    static func previewValue() -> Self {
        .init(
            id: "id",
            title: "Green hall",
            address: "м. Львів, вул. Джерельна, буд. 38",
            colorHex: "#0000ff",
            color2Hex: "#0000ff")
    }
}

public extension Activity {
    static func previewValue() -> Self {
        .init(
            id: "id",
            colorHex: "#000000",
            title: "Bachata"
        )
    }
}

public extension WeeklyRecurrence {
    static func previewValue() -> Self {
        .init(
            id: "id",
            interval: 1,
            untilDate: Date.now,
            days: [.monday, .wednesday]
        )
    }
}

public extension UpcomingClassModel {
    static func placeholder() -> Self {
        .init(
            id: UUID().uuidString,
            event: .placeholder(),
            concreateTime: Date(),
        )
    }
}
